//
//  ViewController.swift
//  Rick and Morty app design
//
//  Created by Rufat  on 22.05.24.
//

import UIKit

class HomePageViewController: UIViewController, DidFetchData, UpdateCVdata {
    var textToRemove = ""
    var stateChecker = BoolCases()
    var safetyQuery = ""
    var queryText = ""
    var totalPages = 0
    var filterCellRow : Int = 0
    var filterDataModel = FilterData()
    var safetyArray : [DataModel] = []
    var savedArray: [DataModel] = []
    var networkManager = NetworkManager.shared
    var imageCVdata  : [DataModel] = []
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    @IBOutlet var constraint: NSLayoutConstraint!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet public var dropDown: UITableView!
    @IBOutlet var imagesCollectionView: UICollectionView!
    @IBOutlet var filterCollectionView: UICollectionView!
    @IBOutlet var searchtextField: UITextField!
    @IBOutlet var searchFieldView: UIView!
    @IBOutlet var titleLabel: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData(queryText)
    }
    @IBAction func textFieldTextChanged(_ sender: UITextField) {
        stateChecker.isSearching = true
        guard var text = sender.text else{return}
        let words = text.split(separator: " ").filter { !$0.isEmpty }
        // Join the words with a single space
        let cleanedText = words.joined(separator: " ")
        // Update the text field with the cleaned text
        text = cleanedText
        var isCondition: Bool{
            return !imageCVdata.isEmpty && !stateChecker.isShowingSaved && stateChecker.isSearching
        }
        if isCondition{
            scrollToTop()
            if text != ""{
                if let range = queryText.range(of: self.textToRemove){
                    queryText.removeSubrange(range)
                }
                queryText = safetyQuery + "&name=\(text)"
                imageCVdata.removeAll()
            }
            else {queryText = safetyQuery
                imageCVdata.removeAll()
            }
        }
        else if /*!savedArray.isEmpty,*/ stateChecker.isShowingSaved {
            savedArray = safetyArray.filter({ data in
                data.name.lowercased().contains(text.lowercased())
            })
            imagesCollectionView.reloadData()
        }
        textToRemove = "&name=\(text)"
        networkManager.pageNum = 1
        loadData(queryText)
    }
    func loadData(_ queryText: String) {
        stateChecker.isLoading = true
        activityIndicator.startAnimating()
        networkManager.fetchData(queryText: queryText) {[weak self] items in
            guard let self = self else {return }
            DispatchQueue.main.async {
                self.totalPages = items.info.pages
                self.networkManager.pageNum += 1
                self.imageCVdata.append(contentsOf: items.results)
                self.activityIndicator.stopAnimating()
                self.imagesCollectionView.reloadData()
                self.stateChecker.isLoading = false
            }
        }
    }
    func showError(message: String) {
            DispatchQueue.main.async{
                if self.stateChecker.isSearching {
                    self.imageCVdata.removeAll()
                    self.networkManager.pageNum = 1
                    self.searchtextField.text = ""
                    self.loadData(self.safetyQuery)
                }
                let alert = UIAlertController(title: "Warning", message: "Unable to fetch data", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(action)
                self.present(alert,animated: true)
                self.activityIndicator.stopAnimating()
            }
        }
    func scrollToTop() {
        imagesCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    func createAlert() {
        let alert = UIAlertController(title: "Warning", message: "No saved items to show", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert,animated: true)
    }
    func didUpdateCVdata(data: DataModel, cellRow: Int, isSaved : Bool) {
        if isSaved{
            savedArray.append(data)
            imageCVdata[cellRow].isSaved = true
        }
        else{
            savedArray.removeAll { cellData in
                cellData.id == data.id
            }
            imageCVdata[cellRow].isSaved = false
        }
        safetyArray = savedArray
    }
    func reloadData() {
        imagesCollectionView.reloadData()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.227, green: 0.02, blue: 0.392 ,alpha: 1)
        let layer = CAGradientLayer()
        layer.colors = [UIColor(red: 0.859, green: 0, blue: 1, alpha: 0.2).cgColor,UIColor(red: 0, green: 0, blue: 0 ,alpha: 0).cgColor]
        layer.frame = view.frame
        view.layer.addSublayer(layer)
        view.bringSubviewToFront(titleLabel)
        view.bringSubviewToFront(filterCollectionView)
        view.bringSubviewToFront(imagesCollectionView)
        view.bringSubviewToFront(dropDown)
        searchFieldView.layer.masksToBounds = true
        searchFieldView.layer.cornerRadius = 15
        searchtextField.addPadding()
        configureScrollViews()
        searchtextField.delegate = self
        tabBar.delegate = self
        networkManager.delegate = self
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        self.view.addSubview(activityIndicator)
//        imagesCollectionView.prefetchDataSource = self
    }
    func configureScrollViews() {
        filterCollectionView.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "FilterCell")
        imagesCollectionView.register(UINib(nibName: "imagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:  "imageCell")
        dropDown.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "reusableCell")
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        filterCollectionView.collectionViewLayout = layout
        filterCollectionView.backgroundColor = .clear
        filterCollectionView.showsHorizontalScrollIndicator = false
        imagesCollectionView.backgroundColor = .clear
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.showsVerticalScrollIndicator = false
        dropDown.separatorStyle = .none
        dropDown.isHidden = true
        dropDown.backgroundColor = .clear
        dropDown.delegate = self
        dropDown.dataSource = self
        dropDown.layer.cornerRadius = 15
    }
}
//Mark -- CollectionViewDelegate and Datasource
extension HomePageViewController : UICollectionViewDelegate, UICollectionViewDataSource,
                           UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imagesCollectionView {
            return  stateChecker.isShowingSaved ? savedArray.count : imageCVdata.count
        } else {
            return filterDataModel.categories.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            let filterCell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
            filterCell.rowOfCell = indexPath.row
            filterCell.layer.cornerRadius = filterCell.frame.width/10
            filterCell.configureCell(dataForFilterCell: filterDataModel)
            return filterCell
        } else {
            let imageCell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell" , for: indexPath) as! imagesCollectionViewCell
            if !imageCVdata.isEmpty, !stateChecker.isShowingSaved{
                let cellData =  imageCVdata[indexPath.row]
                imageCell.configure(data : cellData)
            }
            else if  stateChecker.isShowingSaved {
                let cellData =  savedArray[indexPath.row]
                imageCell.configure(data : cellData)
            }
            return imageCell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == imagesCollectionView {
            return 39
        } else {
            return 9
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == imagesCollectionView {
            return 27
        } else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == filterCollectionView {
            return CGSize(width: 138, height: 28)
        } else {
            return CGSize(width:  160 , height: 215)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            let cell = filterCollectionView.cellForItem(at: indexPath) as! FilterCell
            self.filterCellRow = indexPath.row
            collectionView.isUserInteractionEnabled = true
            dropDown.reloadData()
            stateChecker.isSearching = false
            if cell.filterLabel.text == cell.filterLabelSectionName {
                dropDown.isHidden = !dropDown.isHidden
                constraint.isActive = false
                constraint = dropDown.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                constraint.isActive = true
            } else {
                dropDown.isHidden = true
                filterDataModel.textLabel[self.filterCellRow] = filterDataModel.categories[self.filterCellRow]
                cell.filterButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                collectionView.isUserInteractionEnabled = true
                if let range = queryText.range(of: filterDataModel.filterQueries[filterCellRow]) {
                    queryText.removeSubrange(range)
                }
                imageCVdata.removeAll()
                safetyQuery = queryText
                networkManager.pageNum = 1
                loadData(safetyQuery)
                scrollToTop()
                filterCollectionView.reloadData()
            }
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "CharacterView") as? SelectedCharacterViewController else {
                fatalError("Unable to instantiate view controller with identifier 'YourViewControllerIdentifier'")
            }
            let data = stateChecker.isShowingSaved ? savedArray[indexPath.row] : imageCVdata[indexPath.row]
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .crossDissolve
            viewController.cellData = data
            viewController.rowOfCell = indexPath.row
            viewController.delegate = self
            present(viewController, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == imagesCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 31, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
    }
}
extension HomePageViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDataModel.dropDownData[self.filterCellRow].count - 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! CustomTableViewCell
        cell.titleLabel.text  = filterDataModel.dropDownData[self.filterCellRow][indexPath.row+1]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
//        filterArray[self.row] = dropDownarray[sectionName]![indexPath.row]
        filterDataModel.textLabel[self.filterCellRow] = filterDataModel.dropDownData[self.filterCellRow][indexPath.row+1]
        tableView.isHidden = true
        filterCollectionView.isUserInteractionEnabled = true
        filterCollectionView.reloadData()
        let filterCategory = filterDataModel.categories[self.filterCellRow]
        let cellText = cell.titleLabel.text!
        switch filterCategory {
        case "Gender types" :
            filterDataModel.filterQueries[0] = "&gender=\(cellText)"
            queryText.append("&gender=\(cellText)")
        case "Classifications" :
            filterDataModel.filterQueries[1] = "&type=\(cellText)"
            queryText.append("&type=\(cellText)")
        default :
            filterDataModel.filterQueries[2] = "&status=\(cellText)"
            queryText.append("&status=\(cellText)")
        }
        imageCVdata.removeAll()
        safetyQuery = queryText
        networkManager.pageNum = 1
        scrollToTop()
        loadData(queryText)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }
}
extension HomePageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imagesCollectionView {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            if offsetY > contentHeight - height {
                if   !stateChecker.isLoading  && networkManager.pageNum < self.totalPages {
                    loadData(queryText)
                }
            }
        }
    }
}
extension HomePageViewController : UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?.last{
            stateChecker.isShowingSaved = true
            if savedArray.isEmpty {createAlert()}
            else { scrollToTop()}
            imagesCollectionView.reloadData()
        } else {
            stateChecker.isShowingSaved = false
            imagesCollectionView.reloadData()
            if !imageCVdata.isEmpty {scrollToTop()}
        }
            
    }
}
extension HomePageViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        stateChecker.isSearching = false
    }
}
