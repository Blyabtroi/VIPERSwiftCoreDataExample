//
//  DictPresenter.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 26/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation

class DictPresenter {
    var view: DictViewProtocol?
    var interactor: DictInteractorProtocol?
    var router: DictRouterProtocol?
}

extension DictPresenter: DictPresenterProtocol {
    
    func viewWillAppear() {
        interactor?.retrieveDict()
    }
    
    func didRetrieveWords(_ words: [WordsModel]) {
        view?.showWords(words)
    }
    
    func showError(_ message: String) {
        view?.showError(message)
    }
    
    func didSelectWord(_ word: WordsModel) {
        if let view = view {
            router?.switchToTranslateModule(with: view, and: word)
        }        
    }
    
    func deleteDict() {
        view?.showDeleteDialog()
    }
    
    func deleteDictConfirmed() {
        view?.showSpinner()
        interactor?.deleteDict(callback: { [weak self] in
            self?.interactor?.retrieveDict()
            self?.view?.hideSpinner()
        })
    }
    
    func searchText(_ text: String) {
        interactor?.searchText(text)
    }
    
}
