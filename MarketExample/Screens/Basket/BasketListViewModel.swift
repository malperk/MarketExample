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
    private let provider: MoyaProvider<FixerApi>
    private var baseAbbreviation = "GBP"

    init(with basket: [Product], provider: MoyaProvider<FixerApi>) {
        productsVariable = BehaviorRelay<[Product]>(value: basket)
        self.provider = provider
        loadCurrencySymbols()
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
            .map(Rate.self)
            .subscribe { response in
                switch response {
                case let .success(value):
                    print(value)
                case let .error(error):
                    print(error)
                    break
            } }.disposed(by: disposeBag)
    }
}
