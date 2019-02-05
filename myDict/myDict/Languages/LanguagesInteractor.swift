//
//  LanguagesInteractor.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 22/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation

class LanguagesInteractor: LanguagesInteractorProtocol {
    var presenter: LanguagesPresenterProtocol?
    var localDatamanager: LanguagesLocalDataManagerProtocol?
    
    func retrieveLanguagesList(_ currentLanguageName: String?) {
        do {
            if let languages = try localDatamanager?.retrieveLanguagesList() {
                let languagesList = languages.map({ (lang) -> LanguagesModel in
                    let lm = LanguagesModel(name: lang.name!, identifier: lang.identifier!)
                    lm.check = lang.name == currentLanguageName
                    return lm
                })
                presenter?.didRetrieveLanguages(languagesList)
            }
            
        } catch {
            presenter?.didRetrieveLanguages([])
        }
    }
    
    func setLanguage(for langDirection: LanguagesLeftRight, language: LanguagesModel) {
        try? localDatamanager?.setLanguage(for: langDirection, language: language)
            
    }
    
}
