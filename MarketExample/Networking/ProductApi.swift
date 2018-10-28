//
//  ProductApi.swift
//  MarketExample
//
//  Created by Alper KARATAS on 10/28/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//
import Moya

enum ProductApi {
    case allProducts
}

extension ProductApi: TargetType {
    var baseURL: URL { return URL(string: "https://httpbin.org")! }
    var path: String {
        return "get"
    }
    var method: Moya.Method {
        return .get
    }
    var sampleData: Data {
        return makeExampleData()
    }
    var task: Task {
        return .requestPlain
    }
    var headers: [String: String]? {
        return nil
    }
}

// Moya stub endpoint closure
func customEndpointClosure(_ target: ProductApi) -> Endpoint {
    return Endpoint(url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers)
}

func makeExampleData() -> Data {
    let coffee: Product = Product(name: "Coffee", unitType: .g, unit: 240, price: 2.30, priceType: "£")
    let tea: Product = Product(name: "Tea", unitType: .box, unit: 60, price: 3.10, priceType: "£")
    let sugar: Product = Product(name: "Sugar", unitType: .kg, unit: 1, price: 2.00, priceType: "£")
    let milk: Product = Product(name: "Milk", unitType: .bottle, unit: 1, price: 1.20, priceType: "£")
    let cup: Product = Product(name: "Cup", unitType: nil, unit: nil, price: 0.50, priceType: "£")
    let products = [coffee, tea, sugar, milk, cup]
    let jsonString = try! JSONEncoder().encode(products)
    return jsonString
}

let stubbedProductProvider = MoyaProvider<ProductApi>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider<ProductApi>.immediatelyStub)


