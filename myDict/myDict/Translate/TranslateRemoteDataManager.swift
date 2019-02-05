//
//  TranslateRemoteDataManager.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 24/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import Foundation

class TranslateRemoteDataManager {
    
    
}

extension TranslateRemoteDataManager: TranslateRemoteDataManagerProtocol {
    func translate(text string: String, from leftLangCode: String, to rightLangCode: String, onError: ((String?) -> ())?, onSuccess: @escaping ((String?, String?, Int) -> ())) {
 
        let langs = String(format: "%@-%@", leftLangCode, rightLangCode)
        guard let url = URL(string: String(format: "%@?key=%@&lang=%@", API.url.rawValue, API.key.rawValue, langs)) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = String(format: "text=%@", string).data(using: .utf8)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, responseError -> Void in
            
            do {
                if let responseError = responseError {
                    onError?(responseError.localizedDescription)
                    return
                }
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                let code = json["code"] as? Int ?? CustomErrorCode.unknown.rawValue
                if let text = json["text"] as? [String] {
                    onSuccess(string, text.first, code)
                }
                else {
                    onSuccess(string, nil, code)
                }
            } catch {
                onError?("Connection error")
            }
        })
        
        task.resume()
    }
    
}
