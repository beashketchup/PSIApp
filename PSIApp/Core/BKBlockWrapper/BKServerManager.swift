//
//  BKServerManager.swift
//  BlockTest
//
//  Created by Ashish Parmar on 9/3/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation

public enum BKServerStatus: Error {
    
    case requestSuccess,
    requestFailed,
    invalidURL,
    statusCodeMismatch,
    invalidHTTPResponse,
    invalidRequest,
    uniqueIdExist,
    nullResponse,
    invalidJSONResponse
}

public enum BKRequestType: String {
    
    case get = "GET",
    post = "POST"
}

public enum BKContentType : String {
    
    case none = "NONE",
    json = "application/json",
    xml = "application/xml",
    form = "application/x-www-form-urlencoded"
}

private struct IdentityAndTrust {
    public var identityRef : SecIdentity
    public var trust : SecTrust
    public var certArray : NSArray
}

public class BKRequest : NSObject {
    
    private var request : URLRequest?
    
    public func initWithRequest(_ request : URLRequest) {
        self.request = request
    }
    
    public func getRequest() -> URLRequest? {
        return self.request
    }
}

fileprivate class BKSession : NSObject {
    
    private var requestId : String = ""
    private var session : URLSession?
    private var uniqueKey : String = ""
    
    private var isCancelled = false
    
    public init(with requestId: String) {
        self.requestId = requestId
    }
    
    public func setUniqueId(_ key : String) {
        self.uniqueKey = key
    }
    
    public func getUniqueKeyFor(_ session : URLSession) -> String? {
        if let newSession = self.session {
            if session == newSession {
                return self.uniqueKey
            }
        }
        
        return nil
    }
    
    public func createSession(with timeOut : TimeInterval, request : URLRequest,
                              completionHandler : @escaping (String, Data?, URLResponse?, Error?) -> Swift.Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfig.urlCache = nil
        sessionConfig.timeoutIntervalForRequest = timeOut
        self.session = URLSession(configuration: sessionConfig, delegate: BKServerManager.sharedManager, delegateQueue: nil)
        
        let task = self.session?.dataTask(with: request, completionHandler: { [unowned self]
            (data : Data?, response : URLResponse?, error : Error?) in
            
            guard self.isCancelled == false else {
                return
            }
            
            completionHandler(self.requestId, data, response, error)
        })
        
        task?.resume()
    }
    
    public func cancelSession() {
        
        self.isCancelled = true
        self.uniqueKey = ""
        self.session?.invalidateAndCancel()
    }
}

public class BKServerManager : NSObject  {
    
    static let sharedManager = BKServerManager()
    
    // global variables
    public var serviceTimeout : TimeInterval = 30
    
    private var requestQueueList : [String : BKSession] = [:]
    private var requestP12Map : [String : String] = [:]
    
    
    // MARK: Init methods
    private override init() {}   //This prevents others from using the default '()' initializer for this class.
    
    // MARK: Public Methods
    public func createRequest(_ ofType : BKRequestType, forPath : String,
                              content : BKContentType, basicAuth : (String, String)? = nil) -> BKRequest {
        
        let newBKRequest = BKRequest()
        if let url = URL(string: forPath) {
            
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            request.httpMethod = ofType.rawValue
            if content != .none {
                request.setValue(content.rawValue, forHTTPHeaderField: "Content-Type")
            }
            
            if let (newUser, newPass) = basicAuth {
                let cred = "\(newUser):\(newPass)"
                if let credData = cred.data(using: .utf8) {
                    let base64Data = credData.base64EncodedString()
                    request.setValue("Basic \(base64Data)", forHTTPHeaderField: "Authorization")
                }
            }
            
            newBKRequest.initWithRequest(request)
        }
        
        return newBKRequest
    }
    
    public func createAndExecService(_ forRequest : BKRequest, forReqBody : String?, forP12 : String?,
                                     completion : @escaping ((BKServerStatus, Any?) -> ())) -> String {
        
        guard let newRequest = forRequest.getRequest() else {
            
            completion(.invalidRequest, nil)
            return ""
        }
        
        var modifiedRequest = newRequest
        if let reqData = forReqBody?.data(using: .utf8) {
            modifiedRequest.httpBody = reqData
        }
        
        let uniqueId = createUniqueServiceId()
        guard self.requestQueueList[uniqueId] == nil else {
            
            completion(.uniqueIdExist, nil)
            return ""
        }
        
        let newSession = BKSession(with: uniqueId)
        newSession.createSession(with: self.serviceTimeout, request: modifiedRequest) {
            (requestId : String, data : Data?, response : URLResponse?, error : Error?) in
            
            if let newError = error {
                
                print("Failure: \((newError as NSError).localizedDescription)")
                completion(.requestFailed, nil)
            }
            else {
                guard let newResponse = response as? HTTPURLResponse else {
                    
                    print("Failure: Invalid HTTP Response.")
                    completion(.invalidHTTPResponse, nil)
                    return
                }
                
                guard (200...299).contains(newResponse.statusCode) else {
                    
                    print("Failure: StatusCode is \(newResponse.statusCode)")
                    completion(.statusCodeMismatch, nil)
                    return
                }
                
                guard let newData = data else {
                    
                    print("Failure: Data is invalid.")
                    completion(.nullResponse, nil)
                    return
                }
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: newData, options: .allowFragments)
                    completion(.requestSuccess, jsonObject)
                }
                catch let error as NSError {
                    
                    print("Exception converting json object : \(error)")
                    completion(.invalidJSONResponse, nil)
                }
            }
        }
        
        newSession.setUniqueId(uniqueId)
        self.requestQueueList[uniqueId] = newSession
        if let newP12 = forP12 {
            self.requestP12Map[uniqueId] = newP12
        }
        return uniqueId
    }
    
    fileprivate func cancelService(_ forId : String) {
        
        if let newSession = self.requestQueueList[forId] {
            newSession.cancelSession()
            self.requestQueueList.removeValue(forKey: forId)
        }
        else {
            print("Failure: Invalid Session Id")
        }
    }
    
    // MARK: Private Methods
    fileprivate func createUniqueServiceId() -> String {
        
        let uuid = UUID().uuidString
        return uuid
    }
    
    fileprivate func extractIdentity(_ certData : NSData, certPassword : String) -> IdentityAndTrust {
        
        var identityAndTrust : IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        
        var items: CFArray?
        let certOptions: Dictionary = [ kSecImportExportPassphrase as String : certPassword ];
        // import certificate to read its entries
        securityError = SecPKCS12Import(certData, certOptions as CFDictionary, &items);
        if securityError == errSecSuccess {
            
            let certItems:CFArray = items as CFArray!;
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first;
            
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                
                // grab the identity
                let identityPointer:AnyObject? = certEntry["identity"];
                let secIdentityRef:SecIdentity = identityPointer as! SecIdentity!;
                
                // grab the trust
                let trustPointer:AnyObject? = certEntry["trust"];
                let trustRef:SecTrust = trustPointer as! SecTrust;
                
                // grab the certificate chain
                var certRef: SecCertificate?
                SecIdentityCopyCertificate(secIdentityRef, &certRef);
                let certArray:NSMutableArray = NSMutableArray();
                certArray.add(certRef as SecCertificate!);
                
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef, trust: trustRef, certArray: certArray);
            }
        }
        
        return identityAndTrust;
    }
    
    fileprivate func getUniqueKeyFor(_ session : URLSession) -> String? {
        
        for (eachKey, eachValue) in self.requestQueueList {
            if let newKey = eachValue.getUniqueKeyFor(session) {
                if eachKey == newKey {
                    return eachKey
                }
            }
        }
        
        return nil
    }
}

extension BKServerManager : URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard challenge.previousFailureCount == 0 else {
            
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        if let sender = challenge.sender {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                
                if let trust = challenge.protectionSpace.serverTrust {
                    
                    let cred = URLCredential(trust: trust)
                    sender.use(cred, for: challenge)
                    completionHandler(.useCredential, cred)
                    return
                }
            }
            else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
                
                if let newUnqiueKey = getUniqueKeyFor(session),
                    let p12Cert = self.requestP12Map[newUnqiueKey],
                    let p12CertPass = p12CertificateMap[p12Cert] {
                    
                    if let localCertPath = Bundle.main.url(forResource: p12Cert, withExtension: nil),
                        let localCertData = try? Data(contentsOf: localCertPath) {
                        
                        let identityAndTrust : IdentityAndTrust = extractIdentity((localCertData as NSData), certPassword: p12CertPass)
                        let urlCredential : URLCredential = URLCredential(
                            identity: identityAndTrust.identityRef,
                            certificates: identityAndTrust.certArray as [AnyObject],
                            persistence: URLCredential.Persistence.forSession);
                        
                        completionHandler(URLSession.AuthChallengeDisposition.useCredential, urlCredential);
                        return
                    }
                }
                
                challenge.sender?.cancel(challenge)
                completionHandler(URLSession.AuthChallengeDisposition.rejectProtectionSpace, nil)
            }
            
            sender.performDefaultHandling!(for: challenge)
            return
        }
    }
}

