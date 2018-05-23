//
//  HomeViewController.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController<HomeViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        createViewComponents()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(viewModel: HomeViewModel) {
        super.init(viewModel: viewModel, nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("HomeViewController deallocated")
    }
    
    func createViewComponents() {
        
        let newButton = UIButton(type: .custom)
        newButton.setTitle("Start", for: .normal)
        newButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        newButton.backgroundColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1.0)
        newButton.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 40))
        newButton.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        self.view.addSubview(newButton)
        
        newButton.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
    }
    
    @objc func clickAction(_ sender: UIButton) {
        let vm = PSIMapViewModel(services: viewModel.services)
        vm.loadData()
        viewModel.services.push(vm)
    }
}
