//
//  NewsEndpoint.swift
//  NewsApp2
//
//  Created by Света Шибаева on 03.08.2022.
//

import Foundation

enum NewsEndpoint {
    case getNews(page: Int)
    case getTopHeadlines(category: String?, source: String?, page: Int)
}

extension NewsEndpoint: EndpointProtocol {
    
    var host: String {
        return "newsapi.org"
    }
    
    var path: String {
        switch self {
        case .getNews:
            return "/v2/everything"
        case .getTopHeadlines:
            return "/v2/top-headlines"
        }
        
    }
    
    var params: [String : String] {
        switch self {
        case let .getNews(page):
            return [
                "q": "apple",
                "page": "\(page)",
                "pageSize": "20"
            ]
        case let .getTopHeadlines(category, source, page):
            var params = ["country": "us", "page": "\(page)", "pageSize": "20"]
            params["category"] = category
            params["source"] = source
            return params
        }
    }
    
    var headers: [String : String] {
        ["X-Api-Key": "009bf23be7fa455095ae15b261ac5e0a"]
    }
}


