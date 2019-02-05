//
//  DictProtocols.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 26/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation
import UIKit

protocol DictViewProtocol: class {
    var presenter: DictPresenterProtocol? { get set }
    
    func showWords(_ words: [WordsModel])
    func showError(_ message: String)
    func showDeleteDialog()
    
    func showSpinner()
    func hideSpinner()
}

protocol DictRouterProtocol: class {
    static func configureDictModule(view: DictViewProtocol)
    func switchToTranslateModule(with view: DictViewProtocol, and words: WordsModel)
}

protocol DictPresenterProtocol: class {
    var view: DictViewProtocol? { get set }
    var interactor: DictInteractorProtocol? { get set }
    var router: DictRouterProtocol? { get set }
    
    func viewWillAppear()
    func didRetrieveWords(_ words: [WordsModel])
    
    func didSelectWord(_ word: WordsModel)
    
    func deleteDict()
    func deleteDictConfirmed()
    
    func searchText(_ text: String)
    
    func showError(_ message: String)
}

protocol DictInteractorProtocol: class {
    var presenter: DictPresenterProtocol? { get set }
    
    var localDatamanager: DictLocalDataManagerProtocol? { get set }
    
    func retrieveDict()
    func deleteDict(callback: (()->())?)
    func searchText(_ text: String)
}

protocol DictLocalDataManagerProtocol: class {
    func retrieveDict() throws -> [Dictionaries]
    func deleteDict(callback: (()->())?) throws
    func searchText(_ text: String) throws -> [Dictionaries]
}
