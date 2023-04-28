//
//  Errors.swift
//  NewsApp
//
//  Created by Anton on 05.02.2023.
//

import Foundation

extension NSError {
    static var unexpectedError: Error {
        NSError(domain: "unexpectedError", code: 1)
    }
}
