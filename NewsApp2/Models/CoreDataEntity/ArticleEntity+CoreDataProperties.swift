//
//  ArticleEntity+CoreDataProperties.swift
//  
//
//  Created by Света Шибаева on 10.08.2022.
//
//

import Foundation
import CoreData


extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }

    @NSManaged public var content: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var urlToImage: String?
    @NSManaged public var url: String?
    @NSManaged public var sourceDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var date: String?
    @NSManaged public var saveDate: Date?
    
}
