//
//  ProductListView.swift
//  MarketExample
//
//  Created by Alper KARATAS on 10/28/18.
//  Copyright © 2018 Alper KARATAS. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ProductListView: UITableViewController {
    @IBOutlet var basketButton: UIBarButtonItem!
    private let disposeBag = DisposeBag()
    var viewModel: ProductListViewModelType!

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
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListViewCell", for: indexPath)
                cell.textLabel?.text = item.description

                return cell
            }
            .disposed(by: disposeBag)

        // Error Handling
        viewModel.errorObservable
            .subscribe(onNext: { [weak self] error in
                self?.showAlert("Error", message: error)
            })
            .disposed(by: disposeBag)

        // Basket add Item
        tableView.rx.itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)

        // Basket remove Item
        tableView.rx.itemDeselected
            .bind(to: viewModel.itemDeselected)
            .disposed(by: disposeBag)

        // Next Screen
        basketButton.rx.tap.subscribe({ [unowned self] _ in
            self.showBasketScreen()
        }).disposed(by: disposeBag)
    }

    private func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }

    // Show Basket View
    private func showBasketScreen() {
        // Create View Model For Basket
        let viewModel = BasketListViewModel(with: self.viewModel.getBasket())
        // Create View
        let view = self.storyboard!.instantiateViewController(withIdentifier: "BasketListView") as! BasketListView
        // Assign View Model to View
        view.viewModel = viewModel
        
        self.navigationController?.pushViewController(view, animated: true)
        
    }
}
