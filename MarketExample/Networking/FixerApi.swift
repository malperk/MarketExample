//
//  FixerApi.swift
//  MarketExample
//
//  Created by Alper KARATAS on 10/28/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//

import Foundation
import Moya

////FIXER API FREE TIER DON'T WORK WITH BASE IT RETURN "base_currency_access_restricted"
enum FixerApi {
    case convert(base: String, other: String)
}

extension FixerApi: TargetType {
    var baseURL: URL { return URL(string: "http://data.fixer.io/api")! }
    var path: String {
        return "latest"
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
            return .requestParameters(parameters: ["access_key": "d0d0610d0d2616dcbc0f8f3e3f735529", "base": base, "symbols": other], encoding: URLEncoding.default)
        }
    }
    var headers: [String: String]? {
        return nil
    }
}

let fixerApiProvider = MoyaProvider<FixerApi>()
