//
//  AppDelegate.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ViewModelServicesDelegate {

    var window: UIWindow?
    var services: ViewModelServicesProtocol?
    
    var presenting: UIViewController? {
        return navigationStack.peekAtStack()
    }
    
    private var navigationStack: [UIViewController] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // Root view controller
        services = ViewModelServices(delegate: self)
        let vm = HomeViewModel(services: services!)
        services?.push(vm)
        
        let rootNavigationController = UINavigationController()
        rootNavigationController.navigationBar.isHidden = true
        navigationStack.push(rootNavigationController)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: ViewModelServicesDelegate
    
    func services(_ services: ViewModelServicesProtocol, navigate: NavigationEvent) {
        DispatchQueue.main.async {
            switch navigate {
            case .Push(let vc, let style):
                switch style {
                case .Push:
                    if let top = self.presenting as? UINavigationController {
                        top.pushViewController(vc, animated: true)
                    }
                case .Modal:
                    if let top = self.presenting {
                        let navc = self.wrapNavigation(vc)
                        self.navigationStack.push(navc)
                        top.present(navc, animated: true, completion: nil)
                    }
                }
            case .Pop:
                if let navc = self.presenting as? UINavigationController {
                    if navc.viewControllers.count > 1 {
                        navc.popViewController(animated: true)
                    } else if self.navigationStack.count > 1 {
                        self.navigationStack.pop()?.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.navigationStack.pop()?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func wrapNavigation(_ vc: UIViewController) -> UINavigationController {
        let navc = UINavigationController(rootViewController: vc)
        navc.navigationBar.isTranslucent = false
        return navc
    }
}

