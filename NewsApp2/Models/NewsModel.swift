//
//  NewsModel.swift
//  NewsApp2
//
//  Created by Света Шибаева on 01.08.2022.
//

import Foundation

struct NewsModel: Decodable {    
    let articles: [Article]
}

struct Article: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
    
    var date: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: publishedAt ?? Date())
    }
}

