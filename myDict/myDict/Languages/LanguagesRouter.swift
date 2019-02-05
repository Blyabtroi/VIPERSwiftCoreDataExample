//
//  LanguagesRouter.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 22/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import UIKit

class LanguagesRouter: BaseRouter {
    
}

extension LanguagesRouter: LanguagesRouterProtocol {
    static func createLanguagesModule(for langDirection: LanguagesLeftRight, currentLanguageName: String?, with callback: @escaping (() -> ())) -> UIViewController {
        let navController = mainStoryboard.instantiateViewController(withIdentifier: "LanguagesViewController")
        if let view = navController.children.first as? LanguagesViewProtocol {
            let presenter: LanguagesPresenterProtocol = LanguagesPresenter()
            presenter.langDirection = langDirection
            let interactor: LanguagesInteractorProtocol = LanguagesInteractor()
            let localDataManager: LanguagesLocalDataManagerProtocol = LanguagesLocalDataManager()
            let router: LanguagesRouterProtocol = LanguagesRouter()
            
            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.interactor = interactor
            presenter.callback = callback
            presenter.currentLanguageName = currentLanguageName
            interactor.presenter = presenter
            interactor.localDatamanager = localDataManager
            
            return navController
        }
        return UIViewController()
    }

}
