//
//  NewsFeedViewController.swift
//  NewsApp2
//
//  Created by Света Шибаева on 01.08.2022.
//

import UIKit
import CoreData

class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let newsService = NewsService()
    
    private var news = [Article]()
    private var newsURL: String?
    private var page = 1
    private var isLoading = false
    private var isListEnded = false
    
    var category: String?
    var source: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: NewsCell.identifier)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = activityIndicator
        
        title = category?.capitalized ?? source?.capitalized
        
        fetchData()
    }
    
    @objc private func refresh() {
        guard !isLoading else { return }
        page = 1
        fetchData()
    }
    
    private func fetchData() {
        isLoading = true
        activityIndicator.startAnimating()
        
        newsService.getTopHeadlines(category: category, source: source, page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                let news = response.articles
                
                if self.page == 1 {
                    self.news = news
                } else {
                    self.news += news
                }
                self.isListEnded = news.isEmpty
                self.page += 1
                
            case let .failure(error):
                DispatchQueue.main.async {
                    self.showError(error: error.localizedDescription)
                }   
            }
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                self.isLoading = false
            }
        }
    }
    
    private func checkArticleIsSaved(indexPath: IndexPath) -> Bool {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", news[indexPath.row].url)
        return (try? CoreDataService.shared.context.fetch(fetchRequest))?.isEmpty == false
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        
        if let url = newsURL {
            webViewController.url = URL(string: url)
        }
    }
}

extension NewsFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
  
        newsURL = news[indexPath.row].url
        
        performSegue(withIdentifier: "ShowWebPage", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoading && !isListEnded else { return }
        
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - scrollView.contentOffset.y <= 0 {
            fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let actionProvider: UIContextMenuActionProvider = { _ in
            
            let addToFavoritesAction = UIAction(title: "Add to favorites", image: UIImage(systemName: "heart.fill")) { [weak self] _ in
                guard let self = self else { return }
                let article = self.news[indexPath.row]
                
                ArticleEntity.saveArticle(from: article)
                
                CoreDataService.shared.saveContext()
            }
            
            let sharedAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                guard let self = self else { return }
                
                let shareController = UIActivityViewController(activityItems: [self.news[indexPath.row].url], applicationActivities: nil)
                
                self.present(shareController, animated: true, completion: nil)
            }
            
            var child = [sharedAction]
            
            if !self.checkArticleIsSaved(indexPath: indexPath) {
                child.insert(addToFavoritesAction, at: 0)
            }
            
            return UIMenu(title: "", children: child)
        }
        return UIContextMenuConfiguration(identifier: "contextMenu" as NSCopying, previewProvider: nil, actionProvider: actionProvider)
    }
}

extension NewsFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let article = news[indexPath.row]
        cell.config(news: article)
        
        return cell
    }
}

