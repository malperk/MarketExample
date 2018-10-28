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
    lazy var productsObservable: Observable<[Product]> = self.productsVariable.asObservable()

    private let productsVariable: BehaviorRelay<[Product]>

    private let disposeBag = DisposeBag()
    private var currencySymbols: [CurrencySymbol] = []
    private var baseAbbreviation = "GBP"
    
    init(with basket: [Product]) {
        productsVariable = BehaviorRelay<[Product]>(value: basket)
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
                // handle error
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
    }
}
