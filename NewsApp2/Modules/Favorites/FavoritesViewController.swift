//
//  FavoritesViewController.swift
//  NewsApp2
//
//  Created by Света Шибаева on 10.08.2022.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var articlesEntity = [ArticleEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: NewsCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "saveDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let result = try CoreDataService.shared.context.fetch(fetchRequest)
            articlesEntity = result
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesEntity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let article = articlesEntity[indexPath.row]
        cell.config(news: article)
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let actionProvider: UIContextMenuActionProvider = {_ in
            let editMenu = UIMenu(title: "", children: [
                UIAction(title: "Delete", image: UIImage(systemName: "trash.fill")) { [weak self] _ in
                    guard let self = self else { return }
                    let news = self.articlesEntity[indexPath.row]
                    
                    CoreDataService.shared.context.delete(news)
                    self.articlesEntity.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    
                    do {
                        try CoreDataService.shared.context.save()
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }    
                }
            ])
            return editMenu
        }
        return UIContextMenuConfiguration(identifier: "deleteContextMenu" as NSCopying, previewProvider: nil, actionProvider: actionProvider)
    }
}
