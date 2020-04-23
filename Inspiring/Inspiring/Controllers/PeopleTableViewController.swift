//
//  PersonsTableViewController.swift
//  Inspiring
//
//  Created by Benjamin Mecanovic on 21/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController {
    
    private var viewModel: PeopleTableViewModel!
    private let cellIdentifier = "PersonTableViewCell"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PeopleTableViewModel(delegate: self)
        prepeareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    private func prepeareUI() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }

    // MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightOfRow
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PersonTableViewCell
        let person = viewModel.getPerson(at: indexPath.row)
        cell.config(delegate: self,
                    personIndex: indexPath.row,
                    imageUrl: person.imageUrl,
                    name: person.name,
                    dateOfBirth: person.dateOfBirth,
                    dateOfDeath: person.dateOfDeath,
                    description: person.description)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, _) in
            self?.tabBarController?.selectedIndex = 1
            self?.viewModel.postNotification(withPersonAt: indexPath.row)
        }
        editAction.image = UIImage(systemName: "square.and.pencil")
        editAction.backgroundColor = .systemYellow
         
        let removeAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, _) in
            self?.viewModel.removePerson(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        removeAction.image = UIImage(systemName: "trash")
        removeAction.backgroundColor = .systemRed
         
        return UISwipeActionsConfiguration(actions: [removeAction,editAction])
    }
}

extension PeopleTableViewController: PeopleTableViewModelDelegate {
    
}

extension PeopleTableViewController: PersonTableViewCellDelegate {
    func didTapImageView(ofPersonWith index: Int?) {
        guard let index = index else { return }
        let person = viewModel.getPerson(at: index)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: "Quote", message: person.randomQuote, preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
