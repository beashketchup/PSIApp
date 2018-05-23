//
//  LocationModel.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation

struct LocationModel: Equatable {
    
    // MARK: Properties
    
    let name: String
    let latitude: Double
    let longitude: Double
    
    // MARK: API
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

func ==(lhs: LocationModel, rhs: LocationModel) -> Bool {
    return lhs.name == rhs.name && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
