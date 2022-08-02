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
    let url =  "https://newsapi.org/v2/everything?q=Apple&from=2022-08-01&sortBy=popularity&apiKey=009bf23be7fa455095ae15b261ac5e0a"
    private var newsURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }

    func fetchData() {
        NetworkManager.fetchNews(url: url) { [weak self] newsModel in
            guard let self = self else { return }
            self.news = newsModel.articles
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
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

