//
//  CurrencyService.swift
//  HelloMVVM
//
//  Created by User on 19/9/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

protocol CurrencyServiceProtocol: class {
    func fetchConverter(_ completion: @escaping ((Result<Converter, ErrorResult>) -> Void))
}

final class CurrencyService: CurrencyServiceProtocol {
    static let shared = CurrencyService()

    let endpoint = "http://data.fixer.io/api/latest?access_key=51f7dbbd76b4629ecc2be77c40627361&symbols=USD,CNY,SGD,AUD,CAD,PLN,MXN&format=1"
    var task: URLSessionTask?

    func fetchConverter(_ completion: @escaping ((Result<Converter, ErrorResult>) -> Void)) {
        cancelFetchCurrencies()

        guard let url = URL(string: endpoint) else {
            completion(.failure(.network(string: "Wrong url format")))
            return
        }

        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.network(string: "An error occured during request: \(error.localizedDescription)")))
                return
            }

            if let data = data {
                ParserHelper.parse(data: data, completion: completion)
            }

        }.resume()
    }

    func cancelFetchCurrencies() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}
