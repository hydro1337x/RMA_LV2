//
//  PersonTableViewCell.swift
//  Inspiring
//
//  Created by Benjamin Mecanovic on 22/04/2020.
//  Copyright © 2020 hydro1337x. All rights reserved.
//

import UIKit

protocol PersonTableViewCellDelegate: class {
    func didTapImageView(ofPersonWith index: Int?)
}

class PersonTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var dateOfDeathLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Properties
    var personIndex: Int?
    weak var delegate: PersonTableViewCellDelegate?
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGestureRecognizer()
        personImageView.layer.masksToBounds = true
        personImageView.layer.cornerRadius = 5
        descriptionTextView.layer.masksToBounds = true
        descriptionTextView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        personImageView.image = nil
        nameLabel.text = ""
        dateOfBirthLabel.text = ""
        dateOfDeathLabel.text = ""
        descriptionTextView.text = ""
    }
    
    final func config(delegate: PersonTableViewCellDelegate?, personIndex: Int?, imageUrl: URL, name: String, dateOfBirth: String, dateOfDeath: String, description: String) {
        self.personIndex = personIndex
        self.delegate = delegate
        if let imageData = try? Data(contentsOf: imageUrl) {
            personImageView.image = UIImage(data: imageData)
        }
        nameLabel.text = name
        dateOfBirthLabel.text = dateOfBirth
        dateOfDeathLabel.text = dateOfDeath
        descriptionTextView.text = description
    }
    
    // MARK: - Methods
    
    private func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        personImageView.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap() {
        delegate?.didTapImageView(ofPersonWith: personIndex)
    }
}
