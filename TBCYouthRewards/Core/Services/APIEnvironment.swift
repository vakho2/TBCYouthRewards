//
//  APIEnvironment.swift
//  TBCYouthRewards
//
//  Created by Vakho Aroshidze on 13.03.26.
//

import Foundation

enum APIEnvironment {
    case main

    var baseURL: String {
        switch self {
        case .main:
            return "https://d3igmnfso8cqt8.cloudfront.net/api"
        }
    }
}
