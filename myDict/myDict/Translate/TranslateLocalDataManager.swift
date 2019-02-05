//
//  TranslateLocalDataManager.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 23/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation
import CoreData

class TranslateLocalDataManager: BaseLocalDataManager {
    
}

extension TranslateLocalDataManager: TranslateLocalDataManagerProtocol {
    func retrieveLeftRightLanguages() throws -> Translation {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<Translation> = NSFetchRequest(entityName: String(describing: Translation.self))
        
        return try managedOC.fetch(request).first!
    }
    
    func swapLanguages() throws -> Translation {
        guard let managedOC = CoreDataStore.managedObjectContext else {
            throw PersistenceError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<Translation> = NSFetchRequest(entityName: String(describing: Translation.self))
        
        let translation = try managedOC.fetch(request).first!
        
        let rightLanguage = translation.rightLanguage!.name!
        let leftLanguage = translation.leftLanguage!.name!
        
        translation.leftLanguage = try self.fetchLanguageBy(name: rightLanguage)
        translation.rightLanguage = try self.fetchLanguageBy(name: leftLanguage)
        
        try managedOC.save()
        
        return translation
    }
    
    func store(translation: TranslationModel) throws {
        guard let leftLangCode = translation.leftLangCode, let rightLangCode = translation.rightLangCode else { return }
        
        do {
            if let leftLang = try fetchLanguageBy(identifier: leftLangCode),
                 let rightLang = try fetchLanguageBy(identifier: rightLangCode) {
                
                var leftWord = try fetchWord(word: translation.leftWord!, from: leftLang)
                var rightWord = try fetchWord(word: translation.rightWord!, from: rightLang)
                
                if leftWord != nil && rightWord != nil {
                   let exist = try isTranslationExists(leftWord: leftWord!, rightWord: rightWord!)
                    if exist == true {
                        return
                    }
                }
                
                if leftWord == nil {
                   leftWord = try addWord(word: translation.leftWord!, for: leftLang)
                }
                if rightWord == nil {
                    rightWord = try addWord(word: translation.rightWord!, for: rightLang)
                }
                
                try addToDictionary(leftWord: leftWord!, rightWord: rightWord!)
            }
        }
        catch {
            print("db error")
        }
    }
}
