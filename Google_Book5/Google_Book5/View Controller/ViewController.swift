//
//  ViewController.swift
//  Google_Book5
//
//  Created by jerry on 10/27/19.
//  Copyright © 2019 lpmetor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
   
    var viewModel = ViewModel() {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMain()
    }
    
    func setupMain() {
        viewModel.get(search: "Trump")
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Itunes Albums.."
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        viewModel.bookDelegate = self
        
        tableView.tableFooterView = UIView(frame: .zero)
        
//        NotificationCenter.default.addObserver(forName: Notification.Name.BookNotification, object: nil, queue: .main) { note in
//            guard let userInfo = note.userInfo as? [String:ViewModel] else {return}
//            self.viewModel = userInfo["ViewModel"]!
  //      }
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableCell.identifier, for: indexPath) as! BookTableCell
        let book = viewModel.books[indexPath.row]
        cell.book = book
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = viewModel.books[indexPath.row]
        viewModel.book = book
        goToDetail(with: viewModel)
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        viewModel.get(search: searchText)
        
        navigationItem.searchController?.isActive = false
        
    }
    
}

extension ViewController: BookDelegate {
    func update() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

