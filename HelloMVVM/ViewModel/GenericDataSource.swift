//
//  GenericDataSource.swift
//  HelloMVVM
//
//  Created by User on 19/9/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

class GenericDataSource<T>: NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
}
