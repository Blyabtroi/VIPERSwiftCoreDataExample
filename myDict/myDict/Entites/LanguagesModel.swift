//
//  LanguagesModel.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 22/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation

class LanguagesModel: Comparable {
    var name: String
    var identifier: String
    var check: Bool?
    
    init(name: String, identifier: String) {
        self.name = name
        self.identifier = identifier
    }
    
    static func < (lhs: LanguagesModel, rhs: LanguagesModel) -> Bool {
        return lhs.identifier < rhs.identifier
    }
    
    static func == (lhs: LanguagesModel, rhs: LanguagesModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
}
