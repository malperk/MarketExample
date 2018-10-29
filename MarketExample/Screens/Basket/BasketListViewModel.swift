//
//  BasketListViewModel.swift
//  MarketExample
//
//  Created by Alper KARATAS on 10/28/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift

final class BasketListViewModel: BasketListViewModelType {
    // Protocol Confirm
    lazy var errorObservable: Observable<String> = self.error.asObservable()
    lazy var productsObservable: Observable<[Product]> = self.productsVariable.asObservable()

    private let error = PublishSubject<String>()
    private let productsVariable: BehaviorRelay<[Product]>

    private let disposeBag = DisposeBag()
    private var currencySymbols: [CurrencySymbol] = []
    private let provider: MoyaProvider<CurrencyConverterApi>
    private var baseAbbreviation = "GBP"

    init(with basket: [Product], provider: MoyaProvider<CurrencyConverterApi>) {
        productsVariable = BehaviorRelay<[Product]>(value: basket)
        self.provider = provider
        loadCurrencySymbols()
    }

    deinit {
        print("deinit BasketListViewModel")
    }
}

extension BasketListViewModel {
    func loadCurrencySymbols() {
        if let path = Bundle.main.path(forResource: "CurrencySymbols", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                currencySymbols = try JSONDecoder().decode([CurrencySymbol].self, from: data)
            } catch {
                self.error.onNext("Currency symbols can't load")
            }
        }
    }

    func getCurrencyNames() -> [[String]] {
        let names = currencySymbols.map {
            return $0.currency
        }
        return [names]
    }

    func updatePrice(currencyName: String) {
        guard let abbreviation = self.currencySymbols.first(where: { $0.currency == currencyName })?.abbreviation else {
            error.onNext("Wrong currency symbol")
            return
        }
        let base = baseAbbreviation

        provider.rx.request(.convert(base: base, other: abbreviation))
            .mapJSON()
            .subscribe { response in
                switch response {
                case let .success(value):
                    if let jsonResult = value as? Dictionary<String, AnyObject> {
                        guard let key = jsonResult.keys.first else {
                            self.error.onNext("Currency pair not found")
                            return
                        }
                        guard let multiplier = jsonResult[key]!["val"] as? Double else {
                            self.error.onNext("Currency multiplier not found")
                            return
                        }
                        guard let symbol = self.getSymbol(with: abbreviation) else {
                            self.error.onNext("Currency symbol not found")
                            return
                        }
                        self.baseAbbreviation = abbreviation
                        let updatedProducts = self.productsVariable.value.map({ (product: Product) -> Product in
                            let newProduct = Product(name: product.name,
                                                     unitType: product.unitType,
                                                     unit: product.unit,
                                                     price: product.price * multiplier,
                                                     priceType: symbol)
                            return newProduct
                        })
                        self.productsVariable.accept(updatedProducts)
                    }
                case let .error(error):
                    self.error.onNext(error.localizedDescription)
            } }.disposed(by: disposeBag)
    }

    private func getSymbol(with abbreviation: String) -> String? {
        guard let symbol = self.currencySymbols.first(where: { $0.abbreviation == abbreviation })?.symbol else {
            error.onNext("Wrong abbreviation")
            return nil
        }
        return symbol
    }
}
