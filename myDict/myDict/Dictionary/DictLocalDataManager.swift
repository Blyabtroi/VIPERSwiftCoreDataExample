//
//  DictLocalDataManager.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 26/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation
import CoreData

class DictLocalDataManager: BaseLocalDataManager {
    
}

extension DictLocalDataManager: DictLocalDataManagerProtocol {
    func retrieveDict() throws -> [Dictionaries] {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let translationDirectionRequest: NSFetchRequest<Translation> = NSFetchRequest(entityName: String(describing: Translation.self))
        let translationDirection = try managedOC.fetch(translationDirectionRequest).first!
        
        return try getDictionary(leftLang: translationDirection.leftLanguage!, rightLang: translationDirection.rightLanguage!)
    }
    
    
    func deleteDict(callback: (() -> ())?) throws {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let translationDirectionRequest: NSFetchRequest<Translation> = NSFetchRequest(entityName: String(describing: Translation.self))
        let translationDirection = try managedOC.fetch(translationDirectionRequest).first!
        
        let request: NSFetchRequest<Dictionaries> = NSFetchRequest(entityName: String(describing: Dictionaries.self))
        let predicate = NSPredicate(format: "langLeft == %@ AND langRight == %@", translationDirection.leftLanguage!, translationDirection.rightLanguage!)
        request.predicate = predicate
        let dict = try managedOC.fetch(request)
        for d in dict {
            managedOC.delete(d)
        }
        try managedOC.save()
        
        callback?()
    }
    
    func searchText(_ text: String) throws -> [Dictionaries] {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let translationDirectionRequest: NSFetchRequest<Translation> = NSFetchRequest(entityName: String(describing: Translation.self))
        let translationDirection = try managedOC.fetch(translationDirectionRequest).first!
        
        let request: NSFetchRequest<Dictionaries> = NSFetchRequest(entityName: String(describing: Dictionaries.self))
        let predicate = NSPredicate(format: "(langLeft == %@ AND langRight == %@) AND (wordLeft.name CONTAINS[c] %@ OR wordRight.name CONTAINS[c] %@)", translationDirection.leftLanguage!, translationDirection.rightLanguage!, text, text)
        request.predicate = predicate
        return try managedOC.fetch(request)
    }
    
    
}
