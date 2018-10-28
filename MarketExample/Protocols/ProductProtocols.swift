//
//  ProductProtocols.swift
//  MarketExample
//
//  Created by Alper KARATAS on 10/28/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//

import Foundation
import RxSwift

protocol ProductListType {
    var productsObservable: Observable<[Product]> { get }
}

protocol ProductListViewModelType: ProductListType {
    var errorObservable: Observable<String> { get }
    var itemSelected: PublishSubject<IndexPath> { get }
    var itemDeselected: PublishSubject<IndexPath> { get }
}