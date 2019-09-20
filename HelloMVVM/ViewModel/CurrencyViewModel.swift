//
//  ViewModel.swift
//  HelloMVVM
//
//  Created by User on 19/9/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct CurrencyViewModel {
    weak var dataSource: GenericDataSource<CurrencyRate>?

    init(dataSource: GenericDataSource<CurrencyRate>?) {
        self.dataSource = dataSource
    }

    func fetchCurrencies() {
        CurrencyService.shared.fetchConverter { result in

            DispatchQueue.main.async {
                switch result {
                case let .success(converter):
                    self.dataSource?.data.value = converter.rates
                case let .failure(error):
                    print("Parser error \(error)")
                }
            }
        }
    }
}
