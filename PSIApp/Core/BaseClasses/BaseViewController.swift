//
//  BaseViewController.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class BaseViewController<T: ViewModelProtocol>: UIViewController {
    
    // MARK: Properties
    
    let viewModel: T
    
    // MARK: API
    
    init(viewModel: T, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(viewModel: T) {
        self.init(viewModel: viewModel, nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
