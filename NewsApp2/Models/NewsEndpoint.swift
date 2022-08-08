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
    case getSources
    case getSearchResults(q: String, page: Int)
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
        case .getSources:
            return "/v2/top-headlines/sources"
        case .getSearchResults:
            return "/v2/everything"
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
            var params = ["page": "\(page)", "pageSize": "20"]
              
            if let category = category {
                params["category"] = category
                params["country"] = "us"
            } else if let source = source {
                params["sources"] = source
            }
            return params
        case .getSources:
            let params = ["country": "us"]
            return params
        case let .getSearchResults(q, page):
            let params = ["q": "\(q)", "page": "\(page)", "sortBy": "publishedAt"]
            return params
        }
    }
    
    var headers: [String : String] {
        ["X-Api-Key": "fb58c0e298be462692fbcae752d5fd8d"]
//        ["X-Api-Key": "009bf23be7fa455095ae15b261ac5e0a"]
    }
}


