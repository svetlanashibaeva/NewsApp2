//
//  NewsFeedViewController.swift
//  NewsApp2
//
//  Created by Света Шибаева on 01.08.2022.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var news = [Article]()
    var category: String?
    var source: String?
    
    private var newsURL: String?
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var newsService = NewsService()
    private var page = 1
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = activityIndicator
        
        if category != nil {
            title = category?.capitalized
        } else {
            title = source?.capitalized
        }
        
        
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
        
        let news = news[indexPath.row]
        newsURL = news.url
        
        performSegue(withIdentifier: "ShowWebPage", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoading else { return }
        
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - scrollView.contentOffset.y <= 0 {
            fetchData()
        }
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

