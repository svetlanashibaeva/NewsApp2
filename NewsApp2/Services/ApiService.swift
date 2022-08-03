//
//  ApiService.swift
//  NewsApp2
//
//  Created by Света Шибаева on 03.08.2022.
//

import Foundation

class ApiService<T: Decodable> {
    
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder? = nil) {
        if let decoder = decoder {
            self.decoder = decoder
        } else {
            self.decoder = JSONDecoder()
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.decoder.dateDecodingStrategy = .iso8601
        }
    }
    
    func performRequest(with endpoint: EndpointProtocol, completion: @escaping (Result<T, Error>) -> ()) {
        guard let url = buildUrl(with: endpoint) else { return completion(Result.failure(MyError.urlError))}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = endpoint.headers
        
        resumeTask(urlRequest: urlRequest, completion: completion)
    }
    
    private func buildUrl(with endpoint: EndpointProtocol) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.params.map({ key, value -> URLQueryItem in
            URLQueryItem(name: key, value: value)
        })
        
        return urlComponents.url
    }
    
    private func resumeTask(urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> ()) {
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                if let result = self.parseJSON(withData: data) {
                    completion(Result.success(result))
                } else {
                    completion(Result.failure(MyError.parseError))
                }
            } else if let error = error {
                completion(Result.failure(error))
            } else {
                completion(Result.failure(MyError.unknownError))
            }
        }
        
        task.resume()
    }
    
    private func parseJSON(withData data: Data) -> T? {
        return try? decoder.decode(T.self, from: data)
    }
    
}
