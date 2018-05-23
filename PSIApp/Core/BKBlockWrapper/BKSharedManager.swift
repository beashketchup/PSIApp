//
//  BKSharedManager.swift
//  BlockTest
//
//  Created by Ashish Parmar on 9/3/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation
import UIKit

public class BKSharedManager : NSObject  {
    
    static let sharedManager = BKSharedManager()
    
    // global variables
    let serverWrapper = BKServerWrapper()
    
    // MARK: init methods
    private override init() {}   //This prevents others from using the default '()' initializer for this class.
    
    // MARK: Public methods
    
    public func getPSIData(_ completion : @escaping (([String: Any]) -> ())) {
        
        self.serverWrapper.getPSIData(completion)
    }
}
