//
//  TranslateInteractor.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 23/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation

class TranslateInteractor {
    var presenter: TranslatePresenterProtocol?
    var localDatamanager: TranslateLocalDataManagerProtocol?
    var remoteDatamanager: TranslateRemoteDataManagerProtocol?
}

extension TranslateInteractor: TranslateInteractorProtocol {
    func retrieveLeftRightLanguages() {
        do {
            if let translation = try localDatamanager?.retrieveLeftRightLanguages() {
                let left = LanguagesModel(name: translation.leftLanguage!.name!, identifier: translation.leftLanguage!.identifier!)
                let right = LanguagesModel(name: translation.rightLanguage!.name!, identifier: translation.rightLanguage!.identifier!)
                presenter?.didRetrieveLeftRightLanguages(left, right)
            }
            
        } catch {
            presenter?.showError("Error loading screen")
        }
    }
    
    func swapLanguages() {
        do {
            if let translation = try localDatamanager?.swapLanguages() {
                let left = LanguagesModel(name: translation.leftLanguage!.name!, identifier: translation.leftLanguage!.identifier!)
                let right = LanguagesModel(name: translation.rightLanguage!.name!, identifier: translation.rightLanguage!.identifier!)
                presenter?.didRetrieveLeftRightLanguages(left, right)
            }
            
        } catch {
            presenter?.showError("Error loading screen")
        }
    }

    func translate(text string: String, from leftLangCode: String, to rightLangCode: String, callback: @escaping ((TranslationModel) -> ())) {
        remoteDatamanager?.translate(text: string, from: leftLangCode, to: rightLangCode, onError: { [weak self] (message) in
            if let message = message {
                self?.presenter?.hideActivity()
                self?.presenter?.showError(message)
            }
        }, onSuccess: { (string, result, code) in
            let translation = TranslationModel()
            translation.leftWord = string
            translation.rightWord = result
            translation.leftLangCode = leftLangCode
            translation.rightLangCode = rightLangCode
            translation.code = code
            callback(translation)
        })
    }
    
    func store(translation: TranslationModel) {
        do {
            try localDatamanager?.store(translation: translation)
        } catch {
            presenter?.showError("Error saving")
        }
    }
}
