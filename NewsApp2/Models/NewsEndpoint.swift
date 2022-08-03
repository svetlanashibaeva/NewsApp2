//
//  NewsEndpoint.swift
//  NewsApp2
//
//  Created by Света Шибаева on 03.08.2022.
//

import Foundation

enum NewsEndpoint {
    case getNews(page: Int)
}

extension NewsEndpoint: EndpointProtocol {
    
    var host: String {
        return "newsapi.org"
    }
    
    var path: String {
        return "/v2/everything"
    }
    
    var params: [String : String] {
        switch self {
        case let .getNews(page):
            return [
                "q": "apple",
                "page": "\(page)",
                "pageSize": "20"
            ]
        }
    }
    
    var headers: [String : String] {
        ["X-Api-Key": "009bf23be7fa455095ae15b261ac5e0a"]
    }
}


