//
//  CoreManager.swift
//  Google_Book5
//
//  Created by jerry on 10/27/19.
//  Copyright © 2019 lpmetor. All rights reserved.
//

import Foundation
import CoreData

let core = CoreManager.shared

final class CoreManager {
    
    static let shared = CoreManager()
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        var container = NSPersistentContainer(name: "Google_Book5")
        
        container.loadPersistentStores(completionHandler: { (storeDescrip, err) in
            if let error = err {
                fatalError(error.localizedDescription)
            }
        })
        
        return container
    }()
    

    
    //MARK: Save
    func save(_ book: Book) {
        
        let entity = NSEntityDescription.entity(forEntityName: "CoreBook", in: context)!
        let core = CoreBook(entity: entity, insertInto: context)
        
        //KVC - Key Value Coding - access object property by String
        core.setValue(toStr(from: book.volumeInfo?.authors), forKey: "authors")
        core.setValue(book.volumeInfo?.title, forKey: "title")
        core.setValue(book.volumeInfo?.imageLinks?.smallImage, forKey: "smallImage")
        core.setValue(book.volumeInfo?.imageLinks?.bigImage, forKey: "bigImage")
        core.setValue(book.id, forKey: "id")
        core.setValue(book.volumeInfo?.description, forKey: "des")
        
     
        
        print("Saved Fact To Core")
        saveContext()
        
    }
    
    //MARK: Delete
    func delete(_ book: Book) {
        
        let fetchRequest = NSFetchRequest<CoreBook>(entityName: "CoreBook")
        let predicate = NSPredicate(format: "id==%@", book.id)
        fetchRequest.predicate = predicate
        
        var bookResult = [CoreBook]()
        
        do {
            bookResult = try context.fetch(fetchRequest)
            
            guard let core = bookResult.first else { return }
            context.delete(core)
            print("Deleted Fact From Core: \(book.id)")
            
        } catch {
            print("Couldn't Fetch Fact: \(error.localizedDescription)")
        }
        
        saveContext()
    }
    
    //MARK: Load
    func load() -> [Book] {
        
        let fetchRequest = NSFetchRequest<CoreBook>(entityName: "CoreBook")
        
        var books = [Book]()
        
        do {
         
            let coreBooks = try context.fetch(fetchRequest)
            for core in coreBooks {
                books.append(Book(from: core))
            }
            
        } catch {
            print("Couldn't Fetch Fact: \(error.localizedDescription)")
        }
        
        return books
    }
    
    
    
    //MARK: Helpers
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func toStr(from: [String]?) -> String? {
        var str: String = ""
        if let fro = from {
            for f in fro {
                str += f + ","
            }
        }
        return str
    }
    
}
