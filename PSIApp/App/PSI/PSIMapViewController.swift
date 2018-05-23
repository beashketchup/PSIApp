//
//  PSIMapViewController.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import MapKit

class PSIMapViewController: BaseViewController<PSIMapViewModel> {
    
    fileprivate var mapView = MKMapView()
    fileprivate var floatingView = FloatingView.init(frame: CGRect.zero, forTitle: "", info: "")
    fileprivate var barLine = BarButtonLineView.init(frame: CGRect.zero, forTitles: [])
    fileprivate let util = ServiceUtility.main
    
    fileprivate var selectedTab: ReadingType = .co(.subIndex)
    fileprivate var pointAnnotation: [MKPointAnnotation: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(viewModel: PSIMapViewModel) {
        super.init(viewModel: viewModel, nibName: nil, bundle: nil)
        createViewComponents()
        subscribeToNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("PSIMapViewController deallocated")
        unsubscribeFromNotifications()
    }
    
    func createViewComponents() {
        let screenSize = UIScreen.main.bounds.size
        
        var yPadding: CGFloat = 0
        let newNav = util.createNavBar(screenSize, title: "AIR QUALITY")
        newNav.frame.origin = CGPoint.zero
        self.view.addSubview(newNav)
        
        yPadding += newNav.frame.size.height + 12
        
        var keyMap: [String] = []
        for (_, eachValue) in dataKey {
            keyMap.append(eachValue)
        }
        self.barLine = BarButtonLineView.init(frame: CGRect(x: 0, y: yPadding, width: screenSize.width, height: 44), forTitles: keyMap, delegate: self)
        self.view.addSubview(barLine)
        
        yPadding += barLine.frame.size.height
        self.mapView = MKMapView(frame: CGRect(x: 0, y: yPadding, width: screenSize.width, height: screenSize.height - yPadding))
        self.mapView.delegate = self
        self.view.addSubview(mapView)
        
        self.floatingView = FloatingView.init(frame: CGRect(x: 30, y: screenSize.height - 110, width: screenSize.width - 60, height: 80),
                                              forTitle: "", info: "")
        self.view.addSubview(floatingView)
        
        setInitialLocation()
    }
    
    fileprivate func setInitialLocation() {
        let regionRadius: CLLocationDistance = 45000
        let location: CLLocation = CLLocation(latitude: 1.3521, longitude: 103.8198)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setPSIData(_ forType: ReadingType, forRegion: String) {
        if let newData = self.viewModel.psiData[forType] {
            switch forRegion {
            case "east":
                self.floatingView.updateView(forTitle: "\(newData.east)", info: "Moderate")
                break
            case "west":
                self.floatingView.updateView(forTitle: "\(newData.west)", info: "Moderate")
                break
            case "north":
                self.floatingView.updateView(forTitle: "\(newData.north)", info: "Moderate")
                break
            case "south":
                self.floatingView.updateView(forTitle: "\(newData.south)", info: "Moderate")
                break
            default:
                self.floatingView.updateView(forTitle: "\(newData.national)", info: "Moderate")
                break
            }
        }
    }
    
    // MARK: Notifications (Private)
    fileprivate func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(locationDidChangeNotification(_:)),
                                               name: NSNotification.Name(rawValue: DataNotifications.locationDataChange),
                                               object: viewModel)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(psiDidChangeNotification(_:)),
                                               name: NSNotification.Name(rawValue: DataNotifications.psiDataChange),
                                               object: viewModel)
    }
    
    fileprivate func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func locationDidChangeNotification(_ notification: NSNotification) {
        
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            let locations = weakSelf.viewModel.locationData
            for eachLocation in locations {
                if eachLocation.latitude == 0 && eachLocation.longitude == 0 { continue }
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: eachLocation.latitude, longitude: eachLocation.longitude)
                weakSelf.mapView.addAnnotation(annotation)
                weakSelf.pointAnnotation[annotation] = eachLocation.name
            }
        }
    }
    
    @objc fileprivate func psiDidChangeNotification(_ notification: NSNotification){
        
        DispatchQueue.main.async { [weak self] in
            //guard let weakSelf = self else { return }
            //weakSelf.setPSIData(weakSelf.selectedTab, forRegion: "national")
        }
    }
}

extension PSIMapViewController: MKMapViewDelegate {
    
    @nonobjc public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
    @nonobjc public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pin = view.annotation as? MKPointAnnotation,
            let type = self.pointAnnotation[pin] {
            self.setPSIData(self.selectedTab, forRegion: type)
        }
    }
    
    @nonobjc public func mapViewDidFinishLoadingMap(_ mapView: MKMapView){
        print("fdfd")
    }
}

extension PSIMapViewController: BarButtonDelegate {
    
    func buttonActionClick(_ type: ReadingType) {
        self.selectedTab = type
        self.setPSIData(type, forRegion: "national")
    }
}
