//
//  SourceCell.swift
//  NewsApp2
//
//  Created by Света Шибаева on 05.08.2022.
//

import UIKit

class SourceCell: UITableViewCell {

    @IBOutlet weak var sourceLabel: UILabel!
    
    func config(source: Source) {
        sourceLabel.text = source.name
    }

}
