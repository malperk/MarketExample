//
//  BasketListView.swift
//  MarketExample
//
//  Created by Alper KARATAS on 10/28/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class BasketListView: UITableViewController {
    @IBOutlet var changeCurrencyButton: UIBarButtonItem!
    @IBOutlet var totalPriceLabel: UILabel!
    private let disposeBag = DisposeBag()
    var viewModel: BasketListViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = nil
        tableView.delegate = nil

        bindUI()
    }

    func bindUI() {
        // Tableview cell binding
        viewModel.productsObservable
            .bind(to: tableView.rx.items) { tableView, i, item in
                let indexPath = IndexPath(row: i, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "BasketListViewCell", for: indexPath)
                cell.textLabel?.text = item.description

                return cell
            }
            .disposed(by: disposeBag)

        // Total Price
        viewModel.productsObservable.map { products in
            if products.isEmpty {
                return ""
            } else {
                let price = products.reduce(0, { $0 + $1.price })
                return String(format: "%.2f", price) + products.first!.priceType
            }
        }.bind(to: totalPriceLabel.rx.text)
            .disposed(by: disposeBag)

        // Change Currency
        changeCurrencyButton.rx.tap.subscribe({ [unowned self] _ in
            self.addPickerView()

        }).disposed(by: disposeBag)
    }

    func addPickerView() {}
}
