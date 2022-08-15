//
//  SourcesViewController.swift
//  NewsApp2
//
//  Created by Света Шибаева on 05.08.2022.
//

import UIKit

class SourcesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let sourcesService = SourcesService()
    private var sources = [Source]()
    private var selectedSource: Source?
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SourceCell", bundle: nil), forCellReuseIdentifier: SourceCell.identifier)
        
        fetchData()
    }
    
    func fetchData() {
        activityIndicator.startAnimating()
        
        sourcesService.getSources() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                self.sources = response.sources
                
            case let .failure(error):
                DispatchQueue.main.async {
                    self.showError(error: error.localizedDescription)
                }    
            }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newsFeedViewController = segue.destination as! NewsFeedViewController
       
        newsFeedViewController.source = selectedSource?.id
    }
}

extension SourcesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedSource = sources[indexPath.row]
        
        performSegue(withIdentifier: "ShowSourceNews", sender: self)
    }
}

extension SourcesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SourceCell.identifier, for: indexPath) as! SourceCell
        cell.config(text: sources[indexPath.row].name)
        
        return cell
    }
}
