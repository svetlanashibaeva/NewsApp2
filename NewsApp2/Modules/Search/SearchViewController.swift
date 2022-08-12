//
//  SearchViewController.swift
//  NewsApp2
//
//  Created by Света Шибаева on 08.08.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var news = [Article]()
    
    private var searchController = UISearchController()
    
    private var newsURL: String?
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var newsService = NewsService()
    private var page = 1
    private var isLoading = false
    private var isListEnded = true
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: NewsCell.identifier)
        tableView.tableFooterView = activityIndicator
        searchController.searchBar.placeholder = "Искать..."
//        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func fetchData(query: String?) {
        guard let query = query, !query.isEmpty else {
            return
        }
        isLoading = true
        
        newsService.getSearchResults(q: query, page: page) { [weak self] result in
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
                self.tableView.reloadData()
                self.isLoading = false
            }
        }
    }
    
    private func clear() {
        isListEnded = true
        news = []
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        
        if let url = newsURL {
            webViewController.url = URL(string: url)
        }
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let news = news[indexPath.row]
        newsURL = news.url
        
        performSegue(withIdentifier: "ShowSearchNews", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoading else { return }

        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - scrollView.contentOffset.y <= 0 {
            fetchData(query: searchController.searchBar.text)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: UIContextMenuActionProvider = {_ in
            let editMenu = UIMenu(title: "", children: [
                UIAction(title: "Add to favorites", image: UIImage(systemName: "heart.fill")) { _ in },
                UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    let shareController = UIActivityViewController(activityItems: [self.news[indexPath.row].url], applicationActivities: nil)
                    
                    shareController.completionWithItemsHandler = { _, bool, _, _ in
                        if bool {
                            print("Успешно!")
                        }
                    }
                    
                    self.present(shareController, animated: true, completion: nil)
                }
            ])
            
            return editMenu

        }
        return UIContextMenuConfiguration(identifier: "contextMenu" as NSCopying, previewProvider: nil, actionProvider: actionProvider)
    }
}

extension SearchViewController: UITableViewDataSource {
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

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        timer?.invalidate()
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            clear()
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] (timer) in
            self?.page = 1
            self?.isListEnded = false
            self?.fetchData(query: searchText)
        })
    }
}
