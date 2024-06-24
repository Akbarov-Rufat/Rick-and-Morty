//
//  FilterCell.swift
//  Rick and Morty app design
//
//  Created by Rufat  on 22.05.24.
//

import UIKit

class FilterCell: UICollectionViewCell {
    var rowOfCell : Int = 0
    var filterLabelSectionName : String = ""
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var filterLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configureCell(dataForFilterCell: FilterData) {
        filterLabelSectionName = dataForFilterCell.categories[rowOfCell]
        filterLabel.text = dataForFilterCell.textLabel[rowOfCell]
        if filterLabel.text == filterLabelSectionName {
            filterButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        } else {
            filterButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        filterButton.imageView?.image = nil
        filterLabel.text = ""
    }
    
    
    
    
}
