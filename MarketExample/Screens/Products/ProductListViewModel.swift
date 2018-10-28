//
//  ProductListViewModel.swift
//  MarketExample
//
//  Created by Alper KARATAS on 10/28/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//
import Moya
import RxCocoa
import RxSwift

final class ProductListViewModel: ProductListViewModelType {
    // Protocol Confirm
    lazy var errorObservable: Observable<String> = self.error.asObservable()
    lazy var productsObservable: Observable<[Product]> = self.productsVariable.asObservable()
    let itemSelected = PublishSubject<IndexPath>()
    let itemDeselected = PublishSubject<IndexPath>()

    private let error = PublishSubject<String>()
    private let productsVariable = BehaviorRelay<[Product]>(value: [])

    private var basket: [Product] = []
    private let provider: MoyaProvider<ProductApi>
    private let disposeBag = DisposeBag()

    init(with provider: MoyaProvider<ProductApi>) {
        self.provider = provider
        loadData()

        // Basket Add
        itemSelected.subscribe(onNext: { indexPath in
            guard indexPath.row > -1, indexPath.row < self.productsVariable.value.count else {
                self.error.onNext("Wrong indexPath")
                return
            }
            guard !self.basket.contains(where: { $0.name == self.productsVariable.value[indexPath.row].name }) else {
                self.error.onNext("Product already in basket")
                return
            }

            self.basket.append(self.productsVariable.value[indexPath.row])
        }).disposed(by: disposeBag)

        // Basket Remove
        itemDeselected.subscribe(onNext: { indexPath in
            guard indexPath.row > -1, indexPath.row < self.productsVariable.value.count else {
                self.error.onNext("Wrong indexPath")
                return
            }
            self.basket = self.basket.filter { $0.name != self.productsVariable.value[indexPath.row].name }

        }).disposed(by: disposeBag)
    }

    private func loadData() {
        provider.rx.request(.allProducts)
            .map([Product].self)
            .subscribe { response in
                switch response {
                case let .success(value):
                    self.productsVariable.accept(value)
                case .error:
                    self.error.onNext("Parsing error. Try again later.")
            } }.disposed(by: disposeBag)
    }

    func getBasket() -> [Product] {
        return basket
    }
}
