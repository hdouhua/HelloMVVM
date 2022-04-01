//
//  CurrencyDataSource.swift
//  HelloMVVM
//
//  Created by User on 23/9/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import UIKit

class CurrencyDataSource: GenericDataSource<CurrencyRate>, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return data.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell

        let currencyRate = data.value[indexPath.row]
        cell.currencyRate = currencyRate

        return cell
    }
}
