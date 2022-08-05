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
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "")
                
                if let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) {
                    guard let result = self.parseJSON(from: data, with: T.self) else { return completion(Result.failure(MyError.parseError))}
                    
                    completion(Result.success(result)) }
                else {
                    guard let apiError = self.parseJSON(from: data, with: ApiError.self) else {
                        completion(Result.failure(MyError.unknownError))
                        return
                    }
                    completion(Result.failure(MyError.customError(error: apiError.message)))
                }
            }
        }.resume()
    }
    
    private func parseJSON(from data: Data, with type: Decodable) -> T? {
        return try? decoder.decode(type, from: data)
    }
    
}
