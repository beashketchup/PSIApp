//
//  ViewModelServices.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation

class ViewModelServices: NSObject, ViewModelServicesProtocol {
    
    // MARK: Properties
    
    let mapService: ReadingServiceProtocol
    
    private weak var delegate: ViewModelServicesDelegate?
    
    // MARK: API
    
    init(delegate: ViewModelServicesDelegate?) {
        self.delegate = delegate
        self.mapService = ReadingService()
        super.init()
    }
    
    func push(_ viewModel: ViewModelProtocol) {
        delegate?.services(self, navigate: NavigationEvent(viewModel))
    }
    
    func pop(_ viewModel: ViewModelProtocol) {
        delegate?.services(self, navigate: .Pop)
    }
    
}
