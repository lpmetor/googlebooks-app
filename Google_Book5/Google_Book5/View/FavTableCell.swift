//
//  FavTableCell.swift
//  Google_Book5
//
//  Created by jerry on 9/22/19.
//  Copyright © 2019 lpmetor. All rights reserved.
//

import UIKit

class FavTableCell: UITableViewCell {

    @IBOutlet weak var favBookImage: UIImageView!
    @IBOutlet weak var favBookAuthor: UILabel!
    @IBOutlet weak var favBookTitle: UILabel!
    
    static let identifier = "FavTableCell"
    
    var book: Book! {
        didSet {
            favBookTitle.text = book.volumeInfo?.title
            book.getAuthors{ [weak self] aut in
                self?.favBookAuthor.text = aut
            }
            book.getSmallImage { [weak self] img in
                self?.favBookImage.image = img
            }
        }
    }
    
}
