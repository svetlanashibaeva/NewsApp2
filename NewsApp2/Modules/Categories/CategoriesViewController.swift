//
//  CategoriesViewController.swift
//  NewsApp2
//
//  Created by Света Шибаева on 04.08.2022.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let categories = Category.allCases
    private var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SourceCell", bundle: nil), forCellReuseIdentifier: SourceCell.identifier)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newsFeedViewController = segue.destination as! NewsFeedViewController
       
        newsFeedViewController.category = selectedCategory?.rawValue
    }
}

extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SourceCell.identifier, for: indexPath) as! SourceCell
        let category = categories[indexPath.row]
        cell.config(text: category.rawValue.capitalized)
        
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedCategory = categories[indexPath.row]
        
        performSegue(withIdentifier: "ShowCategoriesNews", sender: self)
    }
}
