//
//  BKServerWrapper.swift
//  BlockTest
//
//  Created by Ashish Parmar on 9/3/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation


public class BKServerWrapper: NSObject {
    
    fileprivate let reachability = Reachability()!
    
    fileprivate var serverPath = ""        
    
    override public init() {
        super.init()
    }
    
    deinit {
        
        print("BKServerWrapper deallocated")
    }
    
    //MARK: Public Methods
    
    public func setBasePath(_ path : String) {
        self.serverPath = path
    }
    
    public func getPSIData(_ completion : @escaping (([String: Any]) -> ())) {
        
        let forPath = BKServiceURL.govAPI.rawValue + BKServiceFunction.psi.rawValue
        let newRequest = self.createServiceRequest(forPath, forType: .get)
        self.executeService(newRequest, forRequestBody: nil, forP12: nil) {
            (status : Bool, data : [String : Any]?) in
            
            guard let newData = data else {
                
                print("***** PSI REQUEST FAILED *****")
                completion([:])
                return
            }
            
            //print("TEST DATA - \(newData)")
            print("***** PSI REQUEST SUCCESS *****")
            completion(newData)
        }
    }
    
    // MARK: Private Methods
    
    fileprivate func createServiceRequest(_ forPath : String, forType : BKRequestType,
                                          basicAuth : (String, String)? = nil) -> BKRequest {
        
        return BKServerManager.sharedManager.createRequest(forType, forPath: forPath,
                                                           content: .json, basicAuth: basicAuth)
    }
    
    fileprivate func createRequestBody(_ requestData : [String : Any]) -> String? {
        
        do {
            let newObject = try JSONSerialization.data(withJSONObject: requestData, options: [])
            if let jsonStr = String.init(data: newObject, encoding: .utf8) {
                return jsonStr
            }
        } catch _ {
            print("Error - Not able to serialize JSON response")
        }
        
        return nil
    }
    
    fileprivate func executeService(_ forRequest : BKRequest, forRequestBody : String?, forP12 : String?,
                                    completion : @escaping ((Bool, [String : Any]?) -> ())) {
        
        let serviceId = BKServerManager.sharedManager.createAndExecService(forRequest, forReqBody: forRequestBody, forP12: forP12) {
            (status : BKServerStatus, result : Any?) in
            
            if let resultData = result as? [String : Any] {
                completion(true, resultData)
            }
            else if let resultData = result as? [[String : Any]] {
                completion(true, ["data" : resultData])
            }
            else {
                completion(false, nil)
            }            
        }
        
        print("Service : \(serviceId)")
    }
}
