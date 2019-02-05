//
//  DictRouter.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 26/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation
import UIKit

class DictRouter: BaseRouter {
    
}

extension DictRouter: DictRouterProtocol {
    static func configureDictModule(view: DictViewProtocol) {
        let presenter: DictPresenterProtocol = DictPresenter()
        let interactor: DictInteractorProtocol = DictInteractor()
        let localDataManager: DictLocalDataManagerProtocol = DictLocalDataManager()
        let router: DictRouterProtocol = DictRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.localDatamanager = localDataManager
    }
    
    func switchToTranslateModule(with view: DictViewProtocol, and words: WordsModel) {
        if let view = view as? UIViewController, let tabsController = view.tabBarController {
            
            TranslateRouter.showTranslateModule(with: tabsController, and: words)
            
        }
    }
}
