//
//  TranslateRouter.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 23/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import UIKit

class TranslateRouter: BaseRouter {
    
}

extension TranslateRouter: TranslateRouterProtocol {
    static func configureTranslateModule(view: TranslateViewProtocol) {
        let presenter: TranslatePresenterProtocol = TranslatePresenter()
        let interactor: TranslateInteractorProtocol = TranslateInteractor()
        let localDataManager: TranslateLocalDataManagerProtocol = TranslateLocalDataManager()
        let remoteDataManager: TranslateRemoteDataManagerProtocol = TranslateRemoteDataManager()
        let router: TranslateRouterProtocol = TranslateRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.localDatamanager = localDataManager
        interactor.remoteDatamanager = remoteDataManager
    }
    
    func presentLanguagesModule(for langDirection: LanguagesLeftRight, currentLanguageName: String?, from view: UIViewController, with callback: @escaping (() -> ())) {
        view.present(LanguagesRouter.createLanguagesModule(for: langDirection, currentLanguageName: currentLanguageName, with: callback), animated: true, completion: nil)
    }

    static func showTranslateModule(with rootView: UIViewController, and words: WordsModel) {
        
        if let tabsController = rootView as? UITabBarController, let view = tabsController.children[Tabs.translate.rawValue] as? TranslateViewProtocol {
            
            view.didTranslate(words)
            
            tabsController.selectedIndex = Tabs.translate.rawValue
        }
        
    }
    
}
