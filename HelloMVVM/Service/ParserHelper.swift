//
//  ParserHelper.swift
//  HelloMVVM
//
//  Created by User on 20/9/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

protocol Parceable {
    static func parseObject(dictionary: [String: AnyObject]) -> Result<Self, ErrorResult>
}

final class ParserHelper {
    static func parse<T: Parceable>(data: Data, completion: (Result<[T], ErrorResult>) -> Void) {
        do {
            if let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] {
                var finalResult: [T] = []

                for object in result {
                    if let dictionary = object as? [String: AnyObject] {
                        switch T.parseObject(dictionary: dictionary) {
                        case .failure:
                            continue
                        case let .success(newModel):
                            finalResult.append(newModel)
                        }
                    }
                }

                completion(.success(finalResult))
            } else {
                completion(.failure(.parser(string: "Json data is not an array")))
            }

        } catch {
            completion(.failure(.parser(string: "Error while parsing json data")))
        }
    }

    static func parse<T: Parceable>(data: Data, completion: (Result<T, ErrorResult>) -> Void) {
        do {
            if let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                switch T.parseObject(dictionary: result) {
                case let .failure(error):
                    completion(.failure(error))
                case let .success(newModel):
                    completion(.success(newModel))
                }
            } else {
                completion(.failure(.parser(string: "Json data is invalid")))
            }
        } catch {
            completion(.failure(.parser(string: "Error while parsing json data")))
        }
    }
}
