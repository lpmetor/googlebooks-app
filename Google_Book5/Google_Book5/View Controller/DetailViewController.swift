//
//  DetailViewController.swift
//  Google_Book5
//
//  Created by jerry on 10/27/19.
//  Copyright © 2019 lpmetor. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookDescription: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetail()
    }
    
    func setupDetail() {
        favoriteButtonText()
        bookTitle.text = viewModel.book.volumeInfo?.title
        bookDescription.text = viewModel.book.volumeInfo?.description
        viewModel.book.getAuthors{ [weak self] aut in
            self?.bookAuthor.text = aut
        }
        viewModel.book.getBigImage { [weak self] img in
            self?.bookImage.image = img
        }

    }
    
    func favoriteButtonText() {
        let book = viewModel.book
        if (viewModel.isFav(book: book!)){
            likeButton.setTitle("Unlike", for: .normal)
            likeButton.setTitleColor(.red, for: .normal)
        }else{
            likeButton.setTitle("Like", for: .normal)
            likeButton.setTitleColor(.blue, for: .normal)
        }
    }

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        let text = likeButton.titleLabel!.text!
        if text.elementsEqual("Like") {
            viewModel.like(book: viewModel.book)
            favoriteButtonText()
        } else {
            viewModel.unlike(book: viewModel.book)
            favoriteButtonText()
        }
    }
    
}
