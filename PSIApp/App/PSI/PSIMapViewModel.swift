//
//  PSIMapViewModel.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation


enum DataNotifications {
    static let locationDataChange = "LocationDataChange"
    static let psiDataChange = "PSIDataChange"
}

let dataKey: [ReadingType: String] = [.co(.subIndex): "CO sub-index", .co(.eightHour): "CO 8 Hour", .so2(.subIndex): "SO2 sub-index",
                                      .so2(.twentyFourHour): "SO2 24 Hour", .o3(.subIndex): "O3 sub-index", .o3(.eightHour): "O3 8 Hour",
                                      .pm10(.subIndex): "PM10 sub-index", .pm10(.twentyFourHour): "PM10 24 Hour",
                                      .no2(.oneHour): "NO2 1 Hour", .pm25(.subIndex): "PM25 sub-index",
                                      .pm25(.twentyFourHour): "PM 24 Hour", .psi(.twentyFourHour): "PSI 24 Hour"]

class PSIMapViewModel: ViewModel {
    
    // MARK: Properties
    
    var psiData: [ReadingType: ReadingModel] {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: DataNotifications.psiDataChange), object: self)
        }
    }
    var locationData: [LocationModel] {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: DataNotifications.locationDataChange), object: self)
        }
    }
    
    // MARK: API
    
    override init(services: ViewModelServicesProtocol) {
        self.psiData = [:]
        self.locationData = []
        super.init(services: services)
    }
    
    func loadData() {
        BKSharedManager.sharedManager.getPSIData { (result) in
            if let regionData = result["region_metadata"] as? [[String: Any]] {
                self.locationData = regionData.compactMap({
                    self.processLocation($0)
                })
            }
            if let items = result["items"] as? [[String: Any]],
                let firstReading = items.first,
                let readingData = firstReading["readings"] as? [String: [String: Double]] {
                var newData: [ReadingType: ReadingModel] = [:]
                for eachKey in dataKey.keys {
                    if let readingObj = readingData[eachKey.name] {
                        newData[eachKey] = self.processReading(readingObj)
                    }
                }
                self.psiData = newData
            }
        }
    }
    
    fileprivate func processLocation(_ object: [String: Any]) -> LocationModel? {
        guard let name = object["name"] as? String,
            let location = object["label_location"] as? [String: Double],
            let latitude = location["latitude"],
            let longitude = location["longitude"] else {
                return nil
        }
        return LocationModel.init(name: name, latitude: latitude, longitude: longitude)
    }
    
    fileprivate func processReading(_ object: [String: Double]) -> ReadingModel {
        var north: Double = 0, east: Double = 0, west: Double = 0, south: Double = 0, national: Double = 0, central: Double = 0
        if let newValue = object["north"] {
            north = newValue
        }
        if let newValue = object["east"] {
            east = newValue
        }
        if let newValue = object["west"] {
            west = newValue
        }
        if let newValue = object["south"] {
            south = newValue
        }
        if let newValue = object["central"] {
            central = newValue
        }
        if let newValue = object["national"] {
            national = newValue
        }
        return ReadingModel.init(national: national, central: central, east: east, west: west, south: south, north: north)
    }
}
