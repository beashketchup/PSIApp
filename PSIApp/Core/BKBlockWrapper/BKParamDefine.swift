//
//  BKParamDefine.swift
//  BKGBServer
//
//  Created by Ashish Parmar on 3/8/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

public enum BKServiceURL : String {
    
    case govAPI = "https://api.data.gov.sg"
}

public enum BKServiceFunction : String {
    
    case psi = "/v1/environment/psi"
}

public let visaUser = "##VISA_USERNAME##"
public let visaPass = "##VISA_PASS##"

public enum BKCert : String {
    
    case b2bCert = "##CERT##.p12"
}

public let p12CertificateMap : [String : String] = ["##CERT##.p12" : "##CERT_PASSWORD##"]
