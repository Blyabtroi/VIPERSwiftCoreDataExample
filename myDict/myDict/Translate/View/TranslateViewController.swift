//
//  ViewController.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 21/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {
    @IBOutlet weak var langLeftButton: UIButton!
    @IBOutlet weak var langRightButton: UIButton!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: TranslatePresenterProtocol?
    
    var translation: BaseModel?
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whiteView.layer.cornerRadius = 6.0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "InputCell", bundle: nil), forCellReuseIdentifier: "InputCell")
        tableView.register(UINib(nibName: "OutputCell", bundle: nil), forCellReuseIdentifier: "OutputCell")
        
        presenter?.viewDidLoad()
    }
    
    @IBAction func langLeftAction(_ sender: Any) {
        presenter?.specifyLanguage(for: .left)
    }
    
    @IBAction func exchangeAction(_ sender: Any) {
        presenter?.swapLanguages()
    }
    
    @IBAction func langRightAction(_ sender: Any) {
        presenter?.specifyLanguage(for: .right)
    }
}

extension TranslateViewController: TranslateViewProtocol {
    
    func showError(_ message: String) {
        DispatchQueue.main.async { 
            let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
    }
    
    func showLanguages(_ leftLanguage: LanguagesModel, _ rightLanguage: LanguagesModel) {
        langLeftButton.setTitle(leftLanguage.name, for: UIControl.State.normal)
        langLeftButton.setTitle(leftLanguage.name, for: UIControl.State.selected)
        langLeftButton.setTitle(leftLanguage.name, for: UIControl.State.focused)
        langRightButton.setTitle(rightLanguage.name, for: UIControl.State.normal)
        langRightButton.setTitle(rightLanguage.name, for: UIControl.State.selected)
        langRightButton.setTitle(rightLanguage.name, for: UIControl.State.focused)
    }
    
    @objc func submitText(_ string: String?) {
        if let timer = timer {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (t) in
            self?.presenter?.submitText(string)
        })
    }
    
    
    func didTranslate(_ translation: BaseModel) {
        self.translation = translation
        DispatchQueue.main.async { [weak self] in            
            if translation is TranslationModel {
                self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: UITableView.RowAnimation.none)
            }
            else {
                self?.tableView.reloadData()
            }
        }
    }
    
    func clearTranslation() {
        self.translation = nil
        tableView.reloadData()
    }
    
    func showActivity() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func hideActivity() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

extension TranslateViewController: UITableViewDelegate {

}

extension TranslateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! InputCell
            cell.selectionStyle = .none
            cell.textField.text = (translation as? WordsModel)?.leftWord
            cell.edititingCallbackBlock = { [weak self] (string) in
                self?.submitText(string)
            }
            cell.enterCallbackBlock = { [weak self] (string) in
                self?.presenter?.submitText(string)
            }
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OutputCell", for: indexPath) as! OutputCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
            cell.selectionStyle = .none
            cell.label.text = (translation as? WordsModel)?.rightWord
            return cell
        }
        return UITableViewCell()
    }
    
}

