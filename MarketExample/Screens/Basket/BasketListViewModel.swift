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

    init(with basket: [Product]) {
        productsVariable = BehaviorRelay<[Product]>(value: basket)
    }
}
