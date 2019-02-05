//
//  LanguagesProtocols.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 22/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation
import UIKit

protocol LanguagesViewProtocol: class {
    var presenter: LanguagesPresenterProtocol? { get set }
    
    func showLanguages(_ languages: [LanguagesModel])
}

protocol LanguagesRouterProtocol: class {
    static func createLanguagesModule(for langDirection: LanguagesLeftRight, currentLanguageName: String?, with callback: @escaping (() -> ())) -> UIViewController
    
}

protocol LanguagesPresenterProtocol: class {
    var view: LanguagesViewProtocol? { get set }
    var interactor: LanguagesInteractorProtocol? { get set }
    var router: LanguagesRouterProtocol? { get set }
    
    var langDirection: LanguagesLeftRight { get set }
    var callback: (() -> ())? { get set }
    var currentLanguageName: String? { get set }
    
    func viewDidLoad()
    func didRetrieveLanguages(_ languages: [LanguagesModel])
    func didSelectLanguage(_ language: LanguagesModel)
}

protocol LanguagesInteractorProtocol: class {
    var presenter: LanguagesPresenterProtocol? { get set }
    
    var localDatamanager: LanguagesLocalDataManagerProtocol? { get set }
    
    func retrieveLanguagesList(_ currentLanguageName: String?)
    func setLanguage(for langDirection: LanguagesLeftRight, language: LanguagesModel)
}

protocol LanguagesLocalDataManagerProtocol: class {
    func retrieveLanguagesList() throws -> [Languages]
    func setLanguage(for langDirection: LanguagesLeftRight, language: LanguagesModel) throws
}
