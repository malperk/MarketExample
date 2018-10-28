//
//  CurrencyConverterApi.swift
//  MarketExample
//
//  Created by Alper KARATAS on 10/28/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//

import Foundation
import Moya

enum CurrencyConverterApi {
    case convert(base: String, other: String)
}

extension CurrencyConverterApi: TargetType {
    var baseURL: URL { return URL(string: "https://free.currencyconverterapi.com/api/v6")! }
    var path: String {
        return "convert"
    }
    var method: Moya.Method {
        return .get
    }
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case let .convert(base, other):
            return .requestParameters(parameters: ["q": base + "_" + other, "compact": "y"], encoding: URLEncoding.default)
        }
    }
    var headers: [String: String]? {
        return nil
    }
}

let currencyConverterApiProvider = MoyaProvider<CurrencyConverterApi>()
