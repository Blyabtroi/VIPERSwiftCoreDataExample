//
//  LanguagesPresenter.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 22/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation

class LanguagesPresenter {

    var view: LanguagesViewProtocol?
    var interactor: LanguagesInteractorProtocol?
    var router: LanguagesRouterProtocol?
    
    var langDirection: LanguagesLeftRight = .left
    var callback: (() -> ())?
    var currentLanguageName: String?
    
    func viewDidLoad() {
        interactor?.retrieveLanguagesList(currentLanguageName)
    }
}

extension LanguagesPresenter: LanguagesPresenterProtocol {
    
    func didRetrieveLanguages(_ languages: [LanguagesModel]) {
        view?.showLanguages(languages)
    }
    
    func didSelectLanguage(_ language: LanguagesModel) {
        interactor?.setLanguage(for: langDirection, language: language)
        callback?()
    }
}
