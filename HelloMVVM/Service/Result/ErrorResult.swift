//
//  ErrorResult.swift
//  HelloMVVM
//
//  Created by User on 19/9/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}
