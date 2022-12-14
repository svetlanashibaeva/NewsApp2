//
//  NewsService.swift
//  NewsApp2
//
//  Created by Света Шибаева on 03.08.2022.
//

import Foundation

class NewsService {
    
    private let apiService = ApiService<NewsModel>()
    
    func getTopHeadlines(category: String?, source: String?, page: Int, completion: @escaping (Result<NewsModel, Error>) -> ()) {
        apiService.performRequest(with: NewsEndpoint.getTopHeadlines(category: category, source: source, page: page), completion: completion)
    }
    
    func getSearchResults(q: String, page: Int, completion: @escaping (Result<NewsModel, Error>) -> ()){
        apiService.performRequest(with: NewsEndpoint.getSearchResults(q: q, page: page), completion: completion)
    }
}
