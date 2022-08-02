//
//  NetworkManager.swift
//  NewsApp2
//
//  Created by Света Шибаева on 01.08.2022.
//

import Foundation

class NetworkManager {
    
    static func fetchNews(url: String, completion: @escaping (_ news: NewsModel)->()) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let newsModel = try decoder.decode(NewsModel.self, from: data)
                completion(newsModel)
            } catch let error {
                print("Error serialization json", error)
            }
        }.resume()
    }
    
}


