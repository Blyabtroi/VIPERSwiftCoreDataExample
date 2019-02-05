//
//  BaseLocalDataManager.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 23/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation
import CoreData

class BaseLocalDataManager {
    class func preloadData() throws {
        guard let managedObjectContext = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let leftlang = NSEntityDescription.insertNewObject(forEntityName: "Languages", into: managedObjectContext) as! Languages
        leftlang.name = "Русский"
        leftlang.identifier = "ru"
        
        let rightlang = NSEntityDescription.insertNewObject(forEntityName: "Languages", into: managedObjectContext) as! Languages
        rightlang.name = "English"
        rightlang.identifier = "en"
        
        let lang = NSEntityDescription.insertNewObject(forEntityName: "Languages", into: managedObjectContext) as! Languages
        lang.name = "Spanish"
        lang.identifier = "es"
        
        let translation = NSEntityDescription.insertNewObject(forEntityName: "Translation", into: managedObjectContext) as! Translation
        translation.leftLanguage = leftlang
        translation.rightLanguage = rightlang
        
        try managedObjectContext.save()
    }
    
    func fetchLanguageBy(name: String) throws -> Languages? {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<Languages> = NSFetchRequest(entityName: String(describing: Languages.self))
        let predicate = NSPredicate(format: "name LIKE %@", name)
        request.predicate = predicate
        return try managedOC.fetch(request).first
    }
    
    func fetchLanguageBy(identifier: String) throws -> Languages? {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<Languages> = NSFetchRequest(entityName: String(describing: Languages.self))
        let predicate = NSPredicate(format: "identifier LIKE %@", identifier)
        request.predicate = predicate
        return try managedOC.fetch(request).first
    }
    
    func fetchWord(word: String, from language: Languages) throws -> Words? {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<Words> = NSFetchRequest(entityName: String(describing: Words.self))
        let predicate = NSPredicate(format: "name LIKE %@ AND SELF.language.identifier LIKE %@", word, language.identifier!)
        request.predicate = predicate
        return try managedOC.fetch(request).first
    }
    
    func addWord(word: String, for language: Languages) throws -> Words {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let w = NSEntityDescription.insertNewObject(forEntityName: "Words", into: managedOC) as! Words
        w.name = word
        w.language = language
        
        try managedOC.save()
        
        return w
    }
    
    func addToDictionary(leftWord: Words, rightWord: Words) throws {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let dict = NSEntityDescription.insertNewObject(forEntityName: "Dictionaries", into: managedOC) as! Dictionaries
        
        dict.langLeft = leftWord.language!
        dict.wordLeft = leftWord
        
        dict.langRight = rightWord.language!
        dict.wordRight = rightWord
        
        try managedOC.save()
    }
    
    func isTranslationExists(leftWord: Words, rightWord: Words) throws -> Bool {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<Dictionaries> = NSFetchRequest(entityName: String(describing: Dictionaries.self))
        let predicate = NSPredicate(format: "wordLeft == %@ AND wordRight == %@", leftWord, rightWord)
        request.predicate = predicate
        if (try managedOC.fetch(request).first) != nil {
            return true
        }
        return false
    }
    
    func getDictionary(leftLang: Languages, rightLang: Languages) throws -> [Dictionaries] {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<Dictionaries> = NSFetchRequest(entityName: String(describing: Dictionaries.self))
        let predicate = NSPredicate(format: "langLeft == %@ AND langRight == %@", leftLang, rightLang)
        request.predicate = predicate
        return try managedOC.fetch(request)
    }
}
