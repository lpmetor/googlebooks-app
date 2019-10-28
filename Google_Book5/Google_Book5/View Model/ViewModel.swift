//
//  ViewModel.swift
//  Google_Book5
//
//  Created by jerry on 10/27/19.
//  Copyright © 2019 lpmetor. All rights reserved.
//

import Foundation

protocol BookDelegate: class {
    func update()
}

protocol FavoriteDelegate: class {
    func update()
}

class ViewModel {
    weak var bookDelegate: BookDelegate!
    weak var favDelegate: FavoriteDelegate!
    
    var books = [Book]() {
        didSet {
            bookDelegate?.update()
        }
    }
    
    var favbooks = [Book]() {
        didSet {
            favDelegate?.update()
        }
    }
    

    var book: Book!
    
    func get(search: String) {
        
        BookService.shared.getBooks(for: search) { [weak self] bookss in
            self?.books = bookss
            print("Books count: \(bookss.count)")
        }
    }
    
    func isFav(book: Book) -> Bool {
        let id = book.id
        print("id of the book \(book.volumeInfo?.title) is: \(id)")
        for book in CoreManager.shared.load() {
            print("id of the favorite \(book.volumeInfo?.title) is: \(book.id)")
            if (book.id == id) {
                 
                return true
            }
        }
        return false
    }
    
    func like(book: Book) {
        CoreManager.shared.save(book)
    }
    
    func unlike(book: Book) {
        CoreManager.shared.delete(book)
    }
    
    func getFavorite() {
            favbooks = CoreManager.shared.load()
    }
}
