//
//  DictViewController.swift
//  myDict
//
//  Created by Vasiliy Kozlov on 21/01/2019.
//  Copyright © 2019 Vasiliy Kozlov. All rights reserved.
//

import UIKit

class DictViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var presenter: DictPresenterProtocol?
    var wordsList: [WordsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier: "WordCell")
        
        activityView.isHidden = true 
        
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        presenter?.deleteDict()
    }
}

extension DictViewController: DictViewProtocol {
    func showSpinner() {
        activityView.startAnimating()
        activityView.isHidden = false
    }
    
    func hideSpinner() {
        activityView.stopAnimating()
        activityView.isHidden = true        
    }
    
    func showWords(_ words: [WordsModel]) {
        wordsList = words
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func showDeleteDialog() {
        let alertController = UIAlertController(title: "Warning", message: "Are you sure to delete this history?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (action) in
            self?.presenter?.deleteDictConfirmed()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
}

extension DictViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectWord(wordsList[indexPath.row])
    }
}

extension DictViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let words = wordsList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! WordCell
        cell.selectionStyle = .none
        cell.leftLabel.text = words.leftWord
        cell.rightLabel.text = words.rightWord
        return cell
    }
    
}

extension DictViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchText(searchText)
    }
}
