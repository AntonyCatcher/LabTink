//
//  Logger.swift
//  NewsApp
//
//  Created by Anton on 05.02.2023.
//

import Foundation

private let logQueue = DispatchQueue(label: "logger", qos: .background)

func log(_ msg: String) {
    logQueue.async {
        print(msg)
    }
}
