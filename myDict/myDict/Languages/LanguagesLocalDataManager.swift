//
//  LanguagesLocalDataManager.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 22/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation
import CoreData

class LanguagesLocalDataManager: BaseLocalDataManager {
    
}

extension LanguagesLocalDataManager: LanguagesLocalDataManagerProtocol {
    func retrieveLanguagesList() throws -> [Languages] {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<Languages> = NSFetchRequest(entityName: String(describing: Languages.self))
        
        return try managedOC.fetch(request)
    }
    

    
    func setLanguage(for langDirection: LanguagesLeftRight, language: LanguagesModel) throws {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let fetchedLanguage = try self.fetchLanguageBy(name: language.name)
        
        let request: NSFetchRequest<Translation> = NSFetchRequest(entityName: String(describing: Translation.self))
        
        let translation = try managedOC.fetch(request)
        if let translation = translation.first {
            if langDirection == .left {
                if fetchedLanguage != translation.rightLanguage {
                    translation.leftLanguage = fetchedLanguage
                }
                else {
                    let rightLanguageCandidate = translation.leftLanguage
                    translation.leftLanguage = fetchedLanguage
                    translation.rightLanguage = rightLanguageCandidate
                }
            }
            else {
                if fetchedLanguage != translation.leftLanguage {
                    translation.rightLanguage = fetchedLanguage
                }
                else {
                    let leftLanguageCandidate = translation.rightLanguage
                    translation.rightLanguage = fetchedLanguage
                    translation.leftLanguage = leftLanguageCandidate
                }
            }
        }
        
        
        try managedOC.save()
    }
    
}
