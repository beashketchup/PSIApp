//
//  ViewModel.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation

class ViewModel: NSObject, ViewModelProtocol {
    
    let services: ViewModelServicesProtocol
    
    init(services: ViewModelServicesProtocol) {
        self.services = services
        super.init()
    }
}
