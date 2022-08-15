//
//  SourcesService.swift
//  NewsApp2
//
//  Created by Света Шибаева on 05.08.2022.
//

import Foundation

class SourcesService {
    
    private let apiService = ApiService<Sources>()
    
    func getSources(completion: @escaping (Result<Sources, Error>) -> ()) {
        apiService.performRequest(with: NewsEndpoint.getSources, completion: completion)
    }
}
