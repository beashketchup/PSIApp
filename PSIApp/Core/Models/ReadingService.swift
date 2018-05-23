//
//  PSIService.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation

protocol ReadingServiceProtocol {
    func update(_ model: ReadingModel) -> ReadingModel
    func delete(_ model: ReadingModel) -> Bool
    func create(national: Double, central: Double, east: Double, west: Double, south: Double, north: Double) -> ReadingModel
}

class ReadingService: NSObject, ReadingServiceProtocol {
    
    func update(_ model: ReadingModel) -> ReadingModel {
        return model
    }
    
    func delete(_ model: ReadingModel) -> Bool {
        return true
    }
    
    func create(national: Double, central: Double, east: Double, west: Double, south: Double, north: Double) -> ReadingModel {
        let newModel = ReadingModel.init(national: national, central: central, east: east, west: west, south: south, north: north)
        return newModel
    }
}
