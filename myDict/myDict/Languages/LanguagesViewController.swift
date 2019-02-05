//
//  LanguagesViewController.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 22/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import UIKit

class LanguagesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var languagesList: [LanguagesModel] = []
    
    var presenter: LanguagesPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        presenter?.viewDidLoad()
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LanguagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectLanguage(languagesList[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

extension LanguagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "languages")
        cell.textLabel?.text = languagesList[indexPath.row].name
        if let font = cell.textLabel?.font, let check = languagesList[indexPath.row].check {
            let boldFont = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(.traitBold)!, size: font.pointSize)
            cell.textLabel?.font = check ? boldFont : font
        }
        return cell
    }
    
}

extension LanguagesViewController: LanguagesViewProtocol {

    func showLanguages(_ languages: [LanguagesModel]) {
        languagesList = languages
        tableView.reloadData()
    }
    
    
}

