//
//  FavoriteViewController.swift
//  Google_Book5
//
//  Created by jerry on 10/27/19.
//  Copyright © 2019 lpmetor. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    var viewModel = ViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavorite()
    }
    
    func setupFav() {
        tableView.tableFooterView = UIView(frame: .zero)
        viewModel.favDelegate = self
    }
    


}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favbooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavTableCell.identifier, for: indexPath) as! FavTableCell
        let favbook = viewModel.favbooks[indexPath.row]
        cell.book = favbook
        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = viewModel.favbooks[indexPath.row]
        viewModel.book = book
        goToDetail(with: viewModel)
    }
}

extension FavoriteViewController: FavoriteDelegate {
    func update() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
