//
//  Product.swift
//  MarketExample
//
//  Created by Alper KARATAS on 10/28/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//

import Foundation

enum UnitType: String {
    case g
    case kg
    case box
    case bottle
}

extension UnitType: Codable {
    enum Key: CodingKey {
        case rawValue
    }

    enum CodingError: Error {
        case unknownValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .g
        case 1:
            self = .kg
        case 2:
            self = .box
        case 3:
            self = .bottle
        default:
            throw CodingError.unknownValue
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .g:
            try container.encode(0, forKey: .rawValue)
        case .kg:
            try container.encode(1, forKey: .rawValue)
        case .box:
            try container.encode(2, forKey: .rawValue)
        case .bottle:
            try container.encode(3, forKey: .rawValue)
        }
    }
}

struct Product {
    let name: String
    let unitType: UnitType?
    let unit: Int?
    let price: Double
    let priceType: String
}

extension Product: Codable {}

extension Product: CustomStringConvertible {
    var description: String {
        var stringDescription = "\(name) - " + String(format: "%.2f", price) + "\(priceType)"
        if let unwrappedUnit = unit, let unwrappedUnitType = unitType {
            switch unwrappedUnitType {
            case .g, .kg:
                stringDescription += " per \(unwrappedUnit.description)"
                stringDescription += unwrappedUnitType.rawValue
            case .bottle:
                stringDescription += " per \(unwrappedUnit == 1 ? "" : unwrappedUnit.description)"
                stringDescription += unwrappedUnitType.rawValue
            case .box:
                stringDescription += " per " + unwrappedUnitType.rawValue
                stringDescription += " \(unwrappedUnit == 1 ? "" : "of " + unwrappedUnit.description)"
            }
        }
        return stringDescription
    }
}
