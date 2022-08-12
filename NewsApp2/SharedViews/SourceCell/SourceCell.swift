//
//  SourceCell.swift
//  NewsApp2
//
//  Created by Света Шибаева on 04.08.2022.
//

import UIKit

class SourceCell: UITableViewCell {
    
    static let identifier = "SourceCell"

    @IBOutlet weak var nameCategoryLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    func config(text: String) {
        backgroundColor = .clear
        nameCategoryLabel.text = text
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
    }
}
