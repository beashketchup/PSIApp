//
//  ReadingType.swift
//  PSIApp
//
//  Created by Ashish Parmar on 23/5/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation

enum ReadingType: Hashable {    
    case so2(ReadingPeriod),
    o3(ReadingPeriod),
    pm10(ReadingPeriod),
    co(ReadingPeriod),
    no2(ReadingPeriod),
    pm25(ReadingPeriod),
    psi(ReadingPeriod)
}

enum ReadingPeriod {
    case subIndex,
    oneHour,
    eightHour,
    twentyFourHour
}

extension ReadingPeriod {
    var name: String {
        switch self {
        case .subIndex:
            return "sub_index"
        case .oneHour:
            return "one_hour_max"
        case .eightHour:
            return "eight_hour_max"
        case .twentyFourHour:
            return "twenty_four_hourly"
        }
    }
}
extension ReadingType {
    var name: String {
        switch self {
        case let .so2(value):
            return "so2_\(value.name)"
        case let .o3(value):
            return "o3_\(value.name)"
        case let .pm10(value):
            return "pm10_\(value.name)"
        case let .co(value):
            return "co_\(value.name)"
        case let .no2(value):
            return "no2_\(value.name)"
        case let .pm25(value):
            return "pm25_\(value.name)"
        case let .psi(value):
            return "psi_\(value.name)"
        }
    }
    
    static func getEquivalent(_ value: String) -> ReadingType {
        switch value {
        case "CO sub-index":
            return .co(.subIndex)
        case "CO 8 Hour":
            return .co(.eightHour)
        case "SO2 sub-index":
            return .so2(.subIndex)
        case "SO2 24 Hour":
            return .so2(.twentyFourHour)
        case "O3 sub-index":
            return .o3(.subIndex)
        case "O3 8 Hour":
            return .o3(.eightHour)
        case "PM10 sub-index":
            return .pm10(.subIndex)
        case "PM10 24 Hour":
            return .pm10(.twentyFourHour)
        case "NO2 1 Hour":
            return .no2(.oneHour)
        case "PM25 sub-index":
            return .pm25(.subIndex)
        case "PM25 24 Hour":
            return .pm25(.twentyFourHour)
        case "PSI 24 Hour":
            return .psi(.twentyFourHour)
        default:
            return .psi(.twentyFourHour)
        }
    }
}

extension ReadingPeriod : Equatable {
    static func ==(lhs: ReadingPeriod, rhs: ReadingPeriod) -> Bool {
        switch (lhs, rhs) {
        case (.subIndex, .subIndex):
            return true
        case (.oneHour, .oneHour):
            return true
        case (.eightHour, .eightHour):
            return true
        case (.twentyFourHour, .twentyFourHour):
            return true
        default:
            return false
        }
    }
}

extension ReadingType : Equatable {
    static func ==(lhs: ReadingType, rhs: ReadingType) -> Bool {
        switch (lhs, rhs) {
        case (.so2(let a), .so2(let b)):
            return a == b
        case (.o3(let a), .o3(let b)):
            return a == b
        case (.pm10(let a), .pm10(let b)):
            return a == b
        case (.co(let a), .co(let b)):
            return a == b
        case (.no2(let a), .no2(let b)):
            return a == b
        case (.pm25(let a), .pm25(let b)):
            return a == b
        case (.psi(let a), .psi(let b)):
            return a == b
        default:
            return false
        }
    }
}
