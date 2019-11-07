//
//  CurrencyViewController.swift
//  HelloMVVM
//
//  Created by User on 19/9/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    let dataSource = CurrencyDataSource()

    lazy var viewModel: CurrencyViewModel = {
        let viewModel = CurrencyViewModel(dataSource: dataSource)

        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        title = "Exchange rate"

        tableView.dataSource = dataSource

        dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel.onErrorHandling = { error in
            let alert = UIAlertController(title: "An error occured", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        viewModel.fetchCurrencies()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
