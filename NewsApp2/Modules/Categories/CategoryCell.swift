//
//  CategoryCell.swift
//  NewsApp2
//
//  Created by Света Шибаева on 04.08.2022.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var nameCategoryLabel: UILabel!
    
    func config(category: Category) {
        nameCategoryLabel.text = category.rawValue.capitalized
    }
    
}
