//
//  DictInteractor.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 26/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation


class DictInteractor {
    var presenter: DictPresenterProtocol?
    var localDatamanager: DictLocalDataManagerProtocol?
    
}

extension DictInteractor: DictInteractorProtocol {
    func retrieveDict() {
        do {
            if let dict = try localDatamanager?.retrieveDict() {
                let wordsModel = dict.map { (d) -> WordsModel in
                    let words = WordsModel()
                    words.leftWord = d.wordLeft?.name
                    words.rightWord = d.wordRight?.name
                    return words
                }
                presenter?.didRetrieveWords(wordsModel)
            }
            
        } catch {
            presenter?.showError("Error loading screen")
        }
    }

    func deleteDict(callback: (() -> ())?) {
        do {
            try localDatamanager?.deleteDict(callback: callback)
            
        } catch {
            callback?()
            presenter?.showError("Error deleting history")
        }
    }
    
    func searchText(_ text: String) {
        do {
            if let dict = try localDatamanager?.searchText(text) {
                let wordsModel = dict.map { (d) -> WordsModel in
                    let words = WordsModel()
                    words.leftWord = d.wordLeft?.name
                    words.rightWord = d.wordRight?.name
                    return words
                }
                if text.count > 0 && wordsModel.count > 0 {
                    presenter?.didRetrieveWords(wordsModel)
                } else if text.count > 0 && wordsModel.count == 0 {
                    presenter?.didRetrieveWords([])
                } else {
                    retrieveDict()
                }
            }
            else {
                retrieveDict()
            }
            
        } catch {
            retrieveDict()
        }
    }
    
    
}
