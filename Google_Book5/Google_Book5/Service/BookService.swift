//
//  BookService.swift
//  Google_Book5
//
//  Created by jerry on 10/27/19.
//  Copyright © 2019 lpmetor. All rights reserved.
//

import Foundation

typealias BookHandler = ([Book]) -> Void

final class BookService {
    
    static let shared = BookService()
    private init() {}
    
    func getBooks(for search: String, completion: @escaping BookHandler) {
        guard let url = BookAPI(search: search).getURL else {
            print("oops")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            if let error = err {
                print("Bad Task: \(error.localizedDescription)")
                completion([])
                return
            }
            
            if let data = dat {
                do {
                    let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
                    let books = bookResponse.books
                    print("Good")
                    completion(books)
                } catch let myError {
                    print("Bad! \(myError.localizedDescription)")
                    completion([])
                    return
                }
            }
        }.resume()
    }
    
}
