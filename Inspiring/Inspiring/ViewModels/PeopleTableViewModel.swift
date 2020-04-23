//
//  PersonsTableViewModel.swift
//  Inspiring
//
//  Created by Benjamin Mecanovic on 21/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit

protocol PeopleTableViewModelDelegate: class {
    
}

class PeopleTableViewModel {
    
    private weak var delegate: PeopleTableViewModelDelegate?
    
    init(delegate: PeopleTableViewModelDelegate?) {
        self.delegate = delegate
    }
    
    final var numberOfRows: Int {
        PeopleRepository.shared.numberOfPeople
    }
    
    var heightOfRow: CGFloat {
        return 175
    }
    
    final func getPerson(at index: Int) -> InspiringPerson {
        return PeopleRepository.shared.get(personAt: index)
    }
    
    final func removePerson(at index: Int) {
        PeopleRepository.shared.remove(personAt: index)
    }
    
    final func postNotification(withPersonAt index: Int) {
        let person = getPerson(at: index)
        NotificationCenter.default.post(name: .editUser, object: nil, userInfo: ["person": person])
    }
    
}
