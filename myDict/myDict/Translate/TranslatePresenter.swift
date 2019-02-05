//
//  TranslatePresenter.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 23/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation
import UIKit

class TranslatePresenter {
    var view: TranslateViewProtocol?
    var interactor: TranslateInteractorProtocol?
    var router: TranslateRouterProtocol?
    
    var text: String?
    var leftLanguage: LanguagesModel?
    var rightLanguage: LanguagesModel?
}

extension TranslatePresenter: TranslatePresenterProtocol {
    func viewDidLoad() {
        interactor?.retrieveLeftRightLanguages()
    }
    
    func didRetrieveLeftRightLanguages(_ leftLanguage: LanguagesModel, _ rightLanguage: LanguagesModel) {
        view?.showLanguages(leftLanguage, rightLanguage)
        
        if let prevLeftLanguage = self.leftLanguage, prevLeftLanguage == leftLanguage {
            self.rightLanguage = rightLanguage
            submitText(text)
        }
        else {
            view?.clearTranslation()
        }
        
        self.leftLanguage = leftLanguage
        self.rightLanguage = rightLanguage
        
    }
    
    func showError(_ message: String) {
        view?.showError(message)
    }
    
    func specifyLanguage(for langDirection: LanguagesLeftRight) {
        let currentLanguageName = langDirection == .left ? self.leftLanguage?.name : self.rightLanguage?.name
        router?.presentLanguagesModule(for: langDirection, currentLanguageName: currentLanguageName, from: view as! UIViewController, with: { [weak self] in
            self?.interactor?.retrieveLeftRightLanguages()
        })
    }

    func swapLanguages() {
        interactor?.swapLanguages()
    }
    
    func submitText(_ string: String?) {
        text = string
        
        guard let string = string else { return }
        
        showActivity()
        
        interactor?.translate(text: string, from: leftLanguage!.identifier, to: rightLanguage!.identifier, callback: { [weak self] (result) in
            
            self?.hideActivity()
            
            self?.view?.didTranslate(result)
            
            if self?.canStoreTranslation(translation: result) == true {
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.interactor?.store(translation: result)
                }
                
            }
        })
    }
    
    func canStoreTranslation(translation: TranslationModel) -> Bool {
        
        if let text = translation.leftWord, let tr = translation.rightWord, let code = translation.code {
            return text.count > 0 && tr.count > 0 && code == CustomErrorCode.success.rawValue && text != tr
        }
        return false
    }
    
    func showActivity() {
        view?.showActivity()
    }
    
    func hideActivity() {
        view?.hideActivity()
    }
    

}
