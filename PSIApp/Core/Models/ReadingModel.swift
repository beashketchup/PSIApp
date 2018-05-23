//
//  PSIModel.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation

struct ReadingModel: Equatable {
    
    // MARK: Properties
    
    let national: Double
    let east: Double
    let west: Double
    let south: Double
    let north: Double
    let central: Double
    
    // MARK: API
    
    init(national: Double, central: Double, east: Double, west: Double, south: Double, north: Double) {
        self.national = national
        self.east = east
        self.west = west
        self.south = south
        self.north = north
        self.central = central
    }
}

func ==(lhs: ReadingModel, rhs: ReadingModel) -> Bool {
    return lhs.national == rhs.national && lhs.central == rhs.central && lhs.east == rhs.east && lhs.west == rhs.west && lhs.north == rhs.north && lhs.south == rhs.south
}
