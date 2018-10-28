//
//  ProductApiTests.swift
//  MarketExampleTests
//
//  Created by Alper KARATAS on 10/28/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//

@testable import MarketExample
import Nimble
import Quick

final class ProductApiTests: QuickSpec {
    override func spec() {
        it("make product stub request") {
            waitUntil(timeout: 5.0) { done in
                stubbedProductProvider.request(.allProducts, completion: { result in
                    switch result {
                    case let .success(response):
                        expect(response.statusCode).to(equal(200))
                        expect(response.data).notTo(beNil())
                    case .failure:
                        fail("expect success")
                    }
                    done()
                })
            }
        }

        it("parse data to Product array") {
            waitUntil(timeout: 5.0) { done in
                stubbedProductProvider.request(.allProducts, completion: { result in
                    switch result {
                    case let .success(response):
                        expect(response.statusCode).to(equal(200))
                        expect(response.data).notTo(beNil())
                        do {
                            let products = try JSONDecoder().decode([Product].self, from: response.data)
                            expect(products).notTo(beEmpty())
                            expect(products.count).to(equal(5))

                        } catch {
                            fail("expect parse success")
                        }
                    case .failure:
                        fail("expect success")
                    }
                    done()
                })
            }
        }
    }
}
