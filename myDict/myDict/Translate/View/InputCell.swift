//
//  InputCell.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 21/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import UIKit

class InputCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    var edititingCallbackBlock: ((String?) -> ())?
    var enterCallbackBlock: ((String?) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
        textField.delegate = self
    }
}

extension InputCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = string
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            result = text.replacingCharacters(in: textRange, with: string)
        }
        
        edititingCallbackBlock?(result)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterCallbackBlock?(textField.text)
        
        return true
    }
}
