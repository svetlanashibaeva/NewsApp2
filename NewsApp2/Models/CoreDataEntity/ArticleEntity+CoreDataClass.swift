//
//  ArticleEntity+CoreDataClass.swift
//  
//
//  Created by Света Шибаева on 10.08.2022.
//
//

import Foundation
import CoreData

@objc(ArticleEntity)
public class ArticleEntity: NSManagedObject {

    static func saveArticle(from article: Article) {
        
        let articleEntity = ArticleEntity(context: CoreDataService.shared.context)
        
        articleEntity.url = article.url
        articleEntity.urlToImage = article.urlToImage
        articleEntity.title = article.title
        articleEntity.content = article.content
        articleEntity.date = article.date
        articleEntity.saveDate = Date()
    }
}
