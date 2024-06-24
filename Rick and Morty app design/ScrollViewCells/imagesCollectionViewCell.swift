//
//  imagesCollectionViewCell.swift
//  Rick and Morty app design
//
//  Created by Rufat  on 23.05.24.
//

import UIKit

class imagesCollectionViewCell: UICollectionViewCell {
    let imageManager = NetworkManager.shared
    @IBOutlet var genderImage: UIImageView!
    @IBOutlet var speciesLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var characterImage: UIImageView!
    @IBOutlet var isSavedImage: UIImageView! {
        didSet {
            isSavedImage.tintColor = UIColor.systemGreen
        }
    }

    @IBOutlet var statusImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(data: DataModel) {
        speciesLabel.textColor = .white
        nameLabel.textColor = .white
        characterImage.layer.cornerRadius = 15
        nameLabel.text = data.name
        speciesLabel.text = data.species
        self.genderImage.image = UIImage(named: data.gender)
        self.statusImage.image = switch data.status {
        case "Alive" :
                .alive
        case "Dead" :
                .dead
        default :
                .unknown1
        }
        imageManager.fetchImage(url: data.image, into: characterImage)
        isSavedImage.image = data.isSaved ? UIImage(systemName: "bookmark.fill") : nil
        contentView.backgroundColor = .clear
    }
    @IBOutlet var savedImage: UIImageView!
    override func prepareForReuse() {
        super.prepareForReuse()
        genderImage.image = nil
        speciesLabel.text = ""
        nameLabel.text = ""
        characterImage.image = nil
    }
    


}
