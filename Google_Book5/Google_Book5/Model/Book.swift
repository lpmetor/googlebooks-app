//
//  Book.swift
//  Google_Book5
//
//  Created by jerry on 10/27/19.
//  Copyright © 2019 lpmetor. All rights reserved.
//

import UIKit

struct BookResponse: Decodable {
    let books: [Book]
    private enum CodingKeys: String, CodingKey {
        case books = "items"
    }
}

class Book: Decodable {
    let volumeInfo: VolumeInfo?
    let id: String
    
    init(from core: CoreBook) {
        self.id = core.id!
        self.volumeInfo = VolumeInfo(title: core.title,
                                    authors: core.authors,
                                    description: core.des,
                                    smallImage: core.smallImage,
                                    bigImage: core.bigImage)
    }
 
    func getAuthors(completion: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            var authors = "By: "
            if let volumeInfo = self.volumeInfo {
                if let auths = volumeInfo.authors {
                    for auth in auths {
                        if auth != "" {
                            authors += auth + ", "
                        }
                    }
                    authors.removeLast()
                    authors.removeLast()
                    completion(String(authors))
                    return

                }
            }
            completion("")
        }
    }
    func getSmallImage(completion: @escaping (UIImage?) -> Void){
        if let img = volumeInfo?.imageLinks?.smallImage {
            cache.downloadFrom(endpoint: img) { dat in
                if let data = dat {
                    DispatchQueue.main.async {
                        completion(UIImage(data: data))
                    }
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func getBigImage(completion: @escaping (UIImage?) -> Void){
        if let img = volumeInfo?.imageLinks?.bigImage {
            cache.downloadFrom(endpoint: img) { dat in
                if let data = dat {
                    DispatchQueue.main.async {
                        completion(UIImage(data: data))
                    }
                }
            }
        } else {
            completion(nil)
        }
    }
}

struct VolumeInfo: Decodable {
    var imageLinks: ImageLinks?
    var title: String?
    var authors: [String]?
    let description: String?
    
    init(title: String? = nil, authors: String? = nil, description: String? = nil, smallImage: String? = nil, bigImage: String? = nil){
        self.imageLinks = ImageLinks(smallImage: smallImage, bigImage: bigImage)
        self.title = title
        self.authors = authors?.components(separatedBy: ",")
        self.description = description
    }
}

struct ImageLinks: Decodable {
    var smallImage: String?
    let bigImage: String?
    private enum CodingKeys: String, CodingKey {
        case smallImage = "smallThumbnail"
        case bigImage = "thumbnail"
    }
    
    init(smallImage: String? = nil, bigImage: String? = nil) {
        self.smallImage = smallImage
        self.bigImage = bigImage
    }
}
