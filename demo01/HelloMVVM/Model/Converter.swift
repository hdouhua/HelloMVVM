//
//  Converter.swift
//  HelloMVVM
//
//  Created by User on 19/9/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct Converter: Parceable {
    let base: String
    let date: String
    let rates: [CurrencyRate]

    static func parseObject(dictionary: [String: AnyObject]) -> Result<Converter, ErrorResult> {
        if let base = dictionary["base"] as? String,
            let date = dictionary["date"] as? String,
            let rates = dictionary["rates"] as? [String: Double] {
            let finalRates: [CurrencyRate] = rates.compactMap { CurrencyRate(currencyIso: $0.key, rate: $0.value) }
            let conversion = Converter(base: base, date: date, rates: finalRates)

            return Result.success(conversion)
        } else {
            print(dictionary)
            return Result.failure(ErrorResult.parser(string: "Unable to parse conversion rate"))
        }
    }
}
