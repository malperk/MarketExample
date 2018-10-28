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
import RxSwift

final class ProductApiTests: QuickSpec {
    let disposeBag = DisposeBag()
    override func spec() {
        // Moya cancel base request when stubbing "load failed with error" message not important
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

        it("parse data to Product array with RXSwift") {
            waitUntil(timeout: 5.0) { done in
                stubbedProductProvider.rx.request(.allProducts)
                    .map([Product].self)
                    .subscribe { response in
                        switch response {
                        case let .success(value):
                            expect(value.count).to(equal(5))
                        case .error:
                            fail("expect success")
                        }
                        done()
                    }.disposed(by: self.disposeBag)
            }
        }
    }
}
