//
//  TranslateProtocols.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 23/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation
import UIKit

protocol TranslateViewProtocol: class {
    var presenter: TranslatePresenterProtocol? { get set }
    
    func showError(_ message: String)
    func showLanguages(_ leftLanguage: LanguagesModel, _ rightLanguage: LanguagesModel)
    
    func didTranslate(_ translation: BaseModel)
    func clearTranslation()
    
    func showActivity()
    func hideActivity()
}

protocol TranslateRouterProtocol: class {
    static func configureTranslateModule(view: TranslateViewProtocol)
    static func showTranslateModule(with rootView: UIViewController, and words: WordsModel)
    
    func presentLanguagesModule(for langDirection: LanguagesLeftRight, currentLanguageName: String?, from view: UIViewController, with callback: @escaping (() -> ()))
}

protocol TranslatePresenterProtocol: class {
    var view: TranslateViewProtocol? { get set }
    var interactor: TranslateInteractorProtocol? { get set }
    var router: TranslateRouterProtocol? { get set }
    
    var text: String? { get set }
    var leftLanguage: LanguagesModel? { get set }
    var rightLanguage: LanguagesModel? { get set }
    
    func viewDidLoad()
    func didRetrieveLeftRightLanguages(_ leftLanguage: LanguagesModel, _ rightLanguage: LanguagesModel)
    func showError(_ message: String)
    
    func specifyLanguage(for langDirection: LanguagesLeftRight)
    func swapLanguages()
    
    func submitText(_ string: String?)
    
    func showActivity()
    func hideActivity()
}

protocol TranslateInteractorProtocol: class {
    var presenter: TranslatePresenterProtocol? { get set }
    
    var localDatamanager: TranslateLocalDataManagerProtocol? { get set }
    var remoteDatamanager: TranslateRemoteDataManagerProtocol? { get set }
    
    func retrieveLeftRightLanguages()
    func swapLanguages()
    
    func translate(text string: String, from leftLangCode: String, to rightLangCode: String, callback: @escaping ((TranslationModel) -> ()))
    func store(translation: TranslationModel)
}

protocol TranslateLocalDataManagerProtocol: class {
    func retrieveLeftRightLanguages() throws -> Translation
    func swapLanguages() throws -> Translation
    func store(translation: TranslationModel) throws
}

protocol TranslateRemoteDataManagerProtocol: class {
    func translate(text string: String, from leftLangCode: String, to rightLangCode: String, onError: ((String?) -> ())?, onSuccess: @escaping ((String?, String?, Int) -> ()))
}
