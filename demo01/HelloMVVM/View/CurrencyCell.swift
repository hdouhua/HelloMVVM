//
//  CurrencyCell.swift
//  HelloMVVM
//
//  Created by User on 19/9/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!

    var currencyRate: CurrencyRate? {
        didSet {
            guard let currencyRate = currencyRate else {
                return
            }

            self.currencyLabel.text = currencyRate.currencyIso
            self.rateLabel.text = "\(currencyRate.rate)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
