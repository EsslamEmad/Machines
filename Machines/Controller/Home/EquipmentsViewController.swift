//
//  EquipmentsViewController.swift
//  Machines
//
//  Created by Esslam Emad on 29/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import RZTransitions
import Kingfisher
import SideMenu
import ImageSlideshow
import Lightbox

class EquipmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var buyOrRentView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var rentButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoriesButton: UIButton!
    
    var buy: Bool!
    var buys = [Equipment]()
    var rents = [Equipment]()
    var search = false
    var filter = false
    var inputs = [InputSource]()

   // var catID: Int!
    //var formType: Int!
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        //searchBar.backgroundColor = .clear
        
        buyOrRentView.layer.borderColor = UIColor.white.cgColor
        buyOrRentView.layer.borderWidth = 1.0
        buyOrRentView.layer.cornerRadius = 10.0
        buyOrRentView.clipsToBounds = true
        //if buy == false {
            didPressRent(nil)
        /*} else {
            didPressBuy(nil)
        }*/
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
       /* if buy{
            self.title = NSLocalizedString("شراء", comment: "")
        }else if let cats = Auth.auth.categories {
            if let found = cats.first(where: {$0.id == category.id}){
                self.title = found.name
            }
        }*/
        self.title = category.name
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
     //   searchBar.backgroundImage = UIImage(named: "rectangle9")
       // searchBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    var gotBuys = false
    @IBAction func didPressBuy(_ sender: Any?) {
        buy = true
        categoriesButton.alpha = 0
        buyButton.backgroundColor = .white
        buyButton.setTitleColor(UIColor(red: 14.0/255.0, green: 74.0/255.0, blue: 164.0/255.0, alpha: 1.0), for: .normal
        )
        rentButton.backgroundColor = .clear
        rentButton.setTitleColor(.white, for: .normal)
        guard buys.count == 0 else {
            tableView.reloadData()
            return
        }
        if gotBuys{
            return
        }
        gotBuys = true
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getBuyEquips)
            }.done {
                self.buys = try! JSONDecoder().decode([Equipment].self, from: $0)
                self.tableView.reloadData()
               // self.countLabel.text = String(self.buys.count) + NSLocalizedString(" نتيجة بحث", comment: "")
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
                self.gotBuys = false
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    var gotRents = false
    @IBAction func didPressRent(_ sender: Any?) {
        buy = false
       // categoriesButton.alpha = 1
        rentButton.backgroundColor = .white
        rentButton.setTitleColor(UIColor(red: 14.0/255.0, green: 74.0/255.0, blue: 164.0/255.0, alpha: 1.0), for: .normal
        )
        buyButton.backgroundColor = .clear
        buyButton.setTitleColor(.white, for: .normal)
       /* guard let _ = category.id else {
            didPressCategories(nil)
            return
        }
        guard rents.count == 0 else {
            //tableView.reloadData()
            filterEquipsBy(categoryID: category.id)
            return
        }
        if gotRents{
            return
        }
        gotRents = true*/
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getEquipsByCategory(id: category.id))
            }.done {
                self.equips = try! JSONDecoder().decode([Equipment].self, from: $0)
                self.tableView.reloadData()
               // self.filterEquipsBy(categoryID: self.category.id)
               // self.countLabel.text = String(self.rents.count) + NSLocalizedString(" نتيجة بحث", comment: "")
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
                self.gotRents = false
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func didPressSideMenu(_ sender: Any?) {
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "SideMenu") as! UISideMenuNavigationController
        sideMenu.sideMenuManager.menuPresentMode = .viewSlideInOut
        sideMenu.sideMenuManager.menuAnimationFadeStrength = 0.75
        
        if Auth.auth.language == "en"{
            sideMenu.leftSide = true
        }
        present(sideMenu, animated: true, completion: nil)
    }

    @IBAction func didPressOrder(_ sender: UIButton!) {
       // performSegue(withIdentifier: "show popover", sender: sender.tag)
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddOrderViewController") as! AddOrderPopoverViewController
        popController.equipID = sender.tag
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.sourceView = self.view
        popController.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width / 2, y: 40, width: 0.5, height: 0.5)
        popController.popoverPresentationController?.delegate = self
        self.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func didPressOnImage(_ sender: UITapGestureRecognizer){
        /*let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddOrderViewController") as! AddOrderPopoverViewController
        popController.equipID = sender.view!.tag
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.sourceView = self.tableView
        popController.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width / 2, y: 0, width: 0, height: 0)
        popController.popoverPresentationController?.delegate = self
        self.present(popController, animated: true, completion: nil)*/
        
        var imagesURL = [String]()
        for image in equips[sender.view!.tag].photos {
            imagesURL.append(image)
        }
        guard imagesURL.count > 0 else { return }
        
        let lightboxImages = imagesURL.map {
            
            return LightboxImage(imageURL: URL(string: $0)!)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        present(lightbox, animated: true, completion: nil)
    }

    
    
    @IBAction func didPressCategories(_ sender: Any?) {
        guard !buy else {
            return
        }
        guard let categories = Auth.auth.categories else {
            Auth.auth.getCategories()
            return
        }
        let alert = UIAlertController(title: NSLocalizedString("إختر نوع المعدة.", comment: ""), message: "", preferredStyle: .actionSheet)
        /*let allAction = UIAlertAction(title: NSLocalizedString("الكل", comment: ""), style: .default, handler: {(UIAlertAction) in
            self.didPressRent(nil)
        })
        alert.addAction(allAction)*/
        for category in categories{
            let action = UIAlertAction(title: category.name, style: .default, handler: {(UIAlertAction) in
                /*self.buyButton.backgroundColor = .clear
                self.buyButton.setTitleColor(.white, for: .normal)
                self.rentButton.backgroundColor = .clear
                self.rentButton.setTitleColor(.white, for: .normal)*/
                self.filterEquipsBy(categoryID: category.id)
               // self.catID = category.id
                //self.formType = category.formType
                
            })
            alert.addAction(action)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func filterEquipsBy(categoryID: Int) {
        guard !buy else{
            return
        }
        
        guard rents.count > 0 else {
            SVProgressHUD.show()
            firstly{
                return API.CallApi(APIRequests.getEquipsByCategory(id: categoryID))
                }.done {
                    self.equips = try! JSONDecoder().decode([Equipment].self, from: $0)
                    self.filter = true
                    self.tableView.reloadData()
                }.catch {
                    self.showAlert(withMessage: $0.localizedDescription)
                }.finally {
                    SVProgressHUD.dismiss()
            }
            return
        }
        equips.removeAll()
        for equip in rents {
            if equip.categoryID == categoryID{
                equips.append(equip)
            }
        }
        filter = true
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show equip" {
            let destination = segue.destination as! EquipmentViewController
            destination.id = (sender as! Int)
            if buy {
                destination.formType = 3
            } else {
                //destination.formType = formType
            }
        }
    }
    
    //Mark: Table view protocols
    
    var equips = [Equipment]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      /*  if filter {
            self.countLabel.text = String(self.equips.count) + NSLocalizedString(" نتيجة بحث", comment: "")
            filter = false
            return equips.count
        }
        if search {
            self.countLabel.text = String(self.equips.count) + NSLocalizedString(" نتيجة بحث", comment: "")
            search = false
            return equips.count
        }
        if buy == false {
            equips = rents
        } else {
            equips = buys
        }*/
        self.countLabel.text = String(self.equips.count) + NSLocalizedString(" نتيجة بحث", comment: "")
        return equips.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EquipmentTableViewCell
       /* if let imgurl = URL(string: equips[indexPath.row].photos[0]){
            cell.photo.kf.setImage(with: imgurl)
            cell.photo.kf.indicatorType = .activity
        }
        
        // Add gesture recognizer to your image view
        cell.photo.addGestureRecognizer(recognizer)*/
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didPressOnImage(_:)))
        self.inputs.removeAll()
        for photo in equips[indexPath.row].photos{
            if let imgurl = URL(string: photo){
                self.inputs.append(KingfisherSource(url: imgurl))
            }
        }
        cell.slideShow.setImageInputs(self.inputs)
        cell.slideShow.slideshowInterval = 5.0
        cell.slideShow.contentScaleMode = .scaleAspectFill
        cell.slideShow.clipsToBounds = true
        cell.slideShow.zoomEnabled = true
        cell.slideShow.addGestureRecognizer(recognizer)
        cell.nameLabel.text = equips[indexPath.row].title
        cell.detailsLabel.text = equips[indexPath.row].content.html2String
        cell.priceButton.setTitle(String(equips[indexPath.row].price) + NSLocalizedString(" ريال سعودي", comment: ""), for: .normal)
        cell.buyOrRentLabel.backgroundColor = UIColor(red: 0, green: 116.0/255.0, blue: 0, alpha: 1)
        cell.buyOrRentLabel.text = NSLocalizedString("بيع", comment: "")
       /* if equips[indexPath.row].buyOrRent == 1 {
            cell.buyOrRentLabel.backgroundColor = UIColor(red: 0, green: 116.0/255.0, blue: 0, alpha: 1)
            cell.buyOrRentLabel.text = NSLocalizedString("بيع", comment: "")
        }else {
            cell.buyOrRentLabel.backgroundColor = UIColor(red: 136.0/255.0, green: 0, blue: 0, alpha: 1)
            cell.buyOrRentLabel.text = NSLocalizedString("إيجار", comment: "")
        }*/
       /* let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.priceButton.bounds
        
        gradientLayer.colors = [UIColor(red: 23.0/255.0, green: 122.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor, UIColor(red: 13.0/255.0, green: 71.0/255.0, blue: 161.0/255.0, alpha: 1).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        cell.priceButton.layer.insertSublayer(gradientLayer, at: 0)*/
        cell.buyButton.tag = equips[indexPath.row].id
        cell.photo.tag = equips[indexPath.row].id
        cell.slideShow.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        buyButton.backgroundColor = .clear
        buyButton.setTitleColor(.white, for: .normal)
        rentButton.backgroundColor = .clear
        rentButton.setTitleColor(.white, for: .normal)
        SVProgressHUD.show()
        categoriesButton.alpha = 0
        firstly{
            return API.CallApi(APIRequests.search(search: searchBar.text ?? ""))
            }.done {
                self.equips = try! JSONDecoder().decode([Equipment].self, from: $0)
                self.search = true
                self.tableView.reloadData()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBAction func unwindFromLogin(_ unwindSegue: UIStoryboardSegue) {
            
    }
    
    //Mark: Popover Protocol Functions
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        // Dim the view behind the popover
        popoverPresentationController.containerView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

}

extension Data {
    var html2AttributedString: NSMutableAttributedString? {
        do {
            return try NSMutableAttributedString(data: self, options: [.documentType: NSMutableAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSMutableAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
}
