//
//  CharacterCollectionViewCell.swift
//  MarvelExample
//
//  Created by Martin Lloyd
//

import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        profileImageView.image = nil
    }

    func configure(name: String) {
        nameLabel.text = name
    }

    func setProfileImage(image: UIImage) {
        profileImageView.image = image
    }
}
