//
//  ViewModelServicesProtocol.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation

protocol ViewModelServicesDelegate: class {
    func services(_ services: ViewModelServicesProtocol, navigate: NavigationEvent)
}

protocol ViewModelServicesProtocol {
    
    var mapService: ReadingServiceProtocol { get }
    
    func push(_ viewModel: ViewModelProtocol)
    func pop(_ viewModel: ViewModelProtocol)
}
