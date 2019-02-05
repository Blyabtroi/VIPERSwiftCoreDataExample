//
//  RootRouter.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 26/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation
import UIKit

class RootRouter: BaseRouter {
    
}

extension RootRouter: RootRouterProtocol {
    static func initTabBarController(window: UIWindow) {
        let tabsController = BaseRouter.mainStoryboard.instantiateViewController(withIdentifier: "Main")
        if let view = tabsController.children[Tabs.translate.rawValue] as? TranslateViewProtocol {
            TranslateRouter.configureTranslateModule(view: view)
        }
        if let navController = tabsController.children[Tabs.dictionary.rawValue] as? UINavigationController, let view = navController.children.first as? DictViewProtocol {
            DictRouter.configureDictModule(view: view)
        }
    
        window.rootViewController = tabsController
        window.makeKeyAndVisible()
    }
}
