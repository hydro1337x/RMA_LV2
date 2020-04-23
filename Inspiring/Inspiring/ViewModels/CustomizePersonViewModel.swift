//
//  CustomizePersonViewModel.swift
//  Inspiring
//
//  Created by Benjamin Mecanovic on 21/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit

enum CustomizationState {
    case edit
    case create
}

protocol CustomizePersonViewModelDelegate: class {
    func didStateChange(person: InspiringPerson?)
}

extension CustomizePersonViewModelDelegate {
    func didStateChange(person: InspiringPerson? = nil) {
        return didStateChange(person: person)
    }
}

class CustomizePersonViewModel {
    
    // MARK: - Properties
    private weak var delegate: CustomizePersonViewModelDelegate?
    private var state: CustomizationState = .create {
        didSet {
            delegate?.didStateChange(person: person)
        }
    }
    private var person: InspiringPerson?
    private var personIndex: Int?
    private var quotes: [String] = []
    private var imageUrl: URL = URL(fileURLWithPath: "")
    
    // MARK: - Init
    init(delegate: CustomizePersonViewModelDelegate?) {
        self.delegate = delegate
        registerOberver()
    }
    
    // MARK: - Methods
    
    private func registerOberver() {
        NotificationCenter.default.addObserver(forName: .editUser, object: nil, queue: nil) { [weak self] (notification) in
            if let person = notification.userInfo?["person"] as? InspiringPerson {
                self?.person = person
                self?.quotes = person.quotes
                self?.imageUrl = person.imageUrl
            }
            self?.state = .edit
        }
    }

    final func resetData() {
        person = nil
        personIndex = nil
        quotes = []
        imageUrl = URL(fileURLWithPath: "")
        state = .create
    }
    
    private func createPerson(name: String, dateOfBirth: String, dateOfDeath: String, description: String) {
        PeopleRepository.shared.append(person: InspiringPerson(name: name,
                                                               description: description,
                                                               imageUrl: imageUrl,
                                                               dateOfBirth: dateOfBirth.description,
                                                               dateOfDeath: dateOfDeath.description,
                                                               quotes: quotes))
    }
    
    private func editPerson(name: String, dateOfBirth: String, dateOfDeath: String, description: String) {
        guard let oldPerson = person else { return }
        let newPerson = InspiringPerson(name: name,
                                        description: description,
                                        imageUrl: imageUrl,
                                        dateOfBirth: dateOfBirth.description,
                                        dateOfDeath: dateOfDeath.description,
                                        quotes: quotes)
        oldPerson.update(newPerson: newPerson)
    }
    
    final func customizePerson(name: String, dateOfBirth: String, dateOfDeath: String, description: String) {
        if state == .create {
            createPerson(name: name,
                         dateOfBirth: dateOfBirth,
                         dateOfDeath: dateOfDeath,
                         description: description)
        } else {
            editPerson(name: name,
                       dateOfBirth: dateOfBirth,
                       dateOfDeath: dateOfDeath,
                       description: description)
        }
    }
    
    final var numberOfRows: Int {
        return quotes.count
    }
    
    var heightOfRow: CGFloat {
        return UITableView.automaticDimension
    }
    
    final func add(quote: String) {
        quotes.append(quote)
    }
    
    final func add(imageUrl: URL) {
        self.imageUrl = imageUrl
    }
    
    final func getQuote(at index: Int) -> String {
        return quotes[index]
    }
    
    final func removeQuote(at index: Int) {
        quotes.remove(at: index)
    }
    
    final func getPerson(at index: Int) -> InspiringPerson {
        return PeopleRepository.shared.get(personAt: index)
    }
}

extension Notification.Name {
    static let editUser = Notification.Name("EditUser")
}
