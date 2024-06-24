//
//  SelectedCharacterViewController.swift
//  Rick and Morty app design
//
//  Created by Rufat  on 23.05.24.
//

import UIKit
protocol UpdateCVdata : AnyObject{
    func didUpdateCVdata(data : DataModel, cellRow : Int, isSaved: Bool)
    func reloadData() 
}
class SelectedCharacterViewController: UIViewController {
    weak var delegate : UpdateCVdata?
    var textDataForLabels = textLabelData()
    var rowOfCell : Int = 0
    var cellData : DataModel?
    var imageManager = NetworkManager.shared
    var checker = false
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var speciesLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var originLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var characterImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI() {
        configureGradient()
        backButton.imageView?.contentMode = .scaleAspectFit
        characterImage.layer.cornerRadius = 20
        configureLabels()
        configureSaved()
        imageManager.fetchImage(url: cellData!.image, into: characterImage)
        view.bringSubviewToFront(nameLabel)
        view.bringSubviewToFront(characterImage)
    }
    func configureSaved() {
        if  cellData!.isSaved {
            saveButton.setImage(.bookmarkfilled, for: .normal)
            checker = true
        } else { saveButton.setImage(.bookmark, for: .normal)
            checker = false
        }
    }
    @IBAction func backTapped(_ sender: Any) {
        delegate?.reloadData()
        dismiss(animated: true)
    }
    @IBAction func saveTapped(_ sender: Any) {
        checker.toggle()
        if checker {
            UIView.transition(with: saveButton,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.saveButton.setImage(.bookmarkfilled, for: .normal)
            },
                              completion: nil)
            cellData!.isSaved = true
            delegate?.didUpdateCVdata(data: cellData!, cellRow: rowOfCell, isSaved: true)
        } else {
            UIView.transition(with: saveButton,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.saveButton.setImage(.bookmark, for: .normal)
            },
                              completion: nil)
            cellData!.isSaved = false
            delegate?.didUpdateCVdata(data: cellData!, cellRow: rowOfCell, isSaved: false)
        }
    }
    func configureGradient() {
        view.backgroundColor = UIColor(red: 0.227, green: 0.02, blue: 0.392 ,alpha: 1)
        let layer = CAGradientLayer()
        layer.colors = [UIColor(red: 0.859, green: 0, blue: 1, alpha: 0.2).cgColor,UIColor(red: 0, green: 0, blue: 0 ,alpha: 0).cgColor]
        layer.frame = view.frame
        view.layer.addSublayer(layer)
    }
    func configureLabels() {
        genderLabel.attributedText = textDataForLabels.genderText.appendMutableString(cellData!.gender.convertToRequiredFont())
        speciesLabel.attributedText = textDataForLabels.speciesText.appendMutableString(cellData!.species.convertToRequiredFont())
        statusLabel.attributedText = textDataForLabels.statusText.appendMutableString(cellData!.status.convertToRequiredFont())
        originLabel.attributedText = textDataForLabels.originText.appendMutableString((cellData!.origin?.name.convertToRequiredFont())!)
        typeLabel.attributedText = cellData!.type != "" ?  textDataForLabels.typeText.appendMutableString(cellData!.type.convertToRequiredFont()) : textDataForLabels.typeText.appendMutableString(String("Unknown").convertToRequiredFont())
        nameLabel.text = cellData!.name
    }
}
