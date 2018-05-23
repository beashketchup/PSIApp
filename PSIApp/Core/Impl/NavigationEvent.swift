//
//  NavigationEvent.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

enum NavigationEvent {
    
    enum PushStyle {
        case Push, Modal
    }
    
    case Push(UIViewController, PushStyle)
    case Pop
    
    init(_ viewModel: ViewModelProtocol) {
        
        if let vm = viewModel as? PSIMapViewModel {
            self = .Push(PSIMapViewController(viewModel: vm), .Push)
        } else if let vm = viewModel as? HomeViewModel {
            self = .Push(HomeViewController(viewModel: vm), .Push)
        } else {
            self = .Push(UIViewController(), .Push)
        }
    }
    
}
