//
//  ProductListViewModelTests.swift
//  MarketExampleTests
//
//  Created by Alper KARATAS on 10/28/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//

@testable import MarketExample
import Nimble
import Quick
import RxSwift

final class ProductListViewModelTests: QuickSpec {
    override func spec() {
        // Moya cancel base request when stubbing "load failed with error" message not important
        let viewModel = ProductListViewModel(with: stubbedProductProvider)
        it("it test productsObservable") {
            waitUntil(timeout: 5.0) { done in
                viewModel.productsObservable.subscribe(onNext: { product in
                    expect(product.count).to(equal(5))
                    done()
                }, onError: { _ in
                    fail("expect success")
                }).disposed(by: DisposeBag())
            }
        }
        
        it("it test itemSelected") {
            expect(viewModel.getBasket().count).to(equal(0))
            viewModel.itemSelected.onNext(IndexPath(row: 0, section: 0))
            expect(viewModel.getBasket().count).to(equal(1))
            viewModel.itemSelected.onNext(IndexPath(row: 0, section: 0))
            expect(viewModel.getBasket().count).to(equal(1))
            viewModel.itemSelected.onNext(IndexPath(row: 100, section: 0))
            expect(viewModel.getBasket().count).to(equal(1))
        }
        it("it test itemDeselected") {
            expect(viewModel.getBasket().count).to(equal(0))
            viewModel.itemSelected.onNext(IndexPath(row: 0, section: 0))
            expect(viewModel.getBasket().count).to(equal(1))
            viewModel.itemDeselected.onNext(IndexPath(row: 0, section: 0))
            expect(viewModel.getBasket().count).to(equal(0))
        }
    }
}
