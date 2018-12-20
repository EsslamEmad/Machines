//
//  EquipmentsListTableViewController.swift
//  Machines
//
//  Created by Esslam Emad on 31/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import RZTransitions

class EquipmentsListTableViewController: UITableViewController {

    
    var state: Int!
    var equips = [Equipment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        tableView.backgroundColor = .clear
        let imageView = UIImageView(image: UIImage(named: "2513524"))
        self.tableView.backgroundView = imageView
        switch state{
        case 1:
            getBoughts()
        case 2:
            getRents()
        case 3:
            getLikes()
        default:
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
       // self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle9"), for: .default)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func getBoughts() {
        self.title = NSLocalizedString("سجل المشتريات", comment: "")
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getUserBuys)
            }.done {
                self.equips = try! JSONDecoder().decode([Equipment].self, from: $0)
                self.tableView.reloadData()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    func getRents() {
        self.title = NSLocalizedString("سجل الإيجارات", comment: "")
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getUserRents)
            }.done {
                self.equips = try! JSONDecoder().decode([Equipment].self, from: $0)
                self.tableView.reloadData()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    func getLikes() {
        self.title = NSLocalizedString("المفضلة", comment: "")
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getWishlist)
            }.done {
                self.equips = try! JSONDecoder().decode([Equipment].self, from: $0)
                self.tableView.reloadData()
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func didPressOrder(_ sender: UIButton!) {
        performSegue(withIdentifier: "show equip", sender: sender.tag)
    }
    
    @IBAction func didPressOnImage(_ sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "show equip", sender: sender.view?.tag)
        print(1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show equip" {
            let destination = segue.destination as! EquipmentViewController
            destination.id = (sender as! Int)
            if state == 3 {
                destination.isLiked = true
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return equips.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EquipmentTableViewCell
        if let imgurl = URL(string: equips[indexPath.row].photos[0]){
            cell.photo.kf.setImage(with: imgurl)
            cell.photo.kf.indicatorType = .activity
        }
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didPressOnImage(_:)))
        cell.bigView.addGestureRecognizer(recognizer)
        
        cell.bigView.tag = equips[indexPath.row].id
        
        cell.nameLabel.text = equips[indexPath.row].title
        cell.detailsLabel.text = equips[indexPath.row].content.html2String
        if equips[indexPath.row].buyOrRent == 1 {
            cell.buyOrRentLabel.backgroundColor = UIColor(red: 0, green: 116.0/255.0, blue: 0, alpha: 1)
            cell.buyOrRentLabel.text = NSLocalizedString("شراء", comment: "")
        }else {
            cell.buyOrRentLabel.backgroundColor = UIColor(red: 136.0/255.0, green: 0, blue: 0, alpha: 1)
            cell.buyOrRentLabel.text = NSLocalizedString("إيجار", comment: "")
        }
        if state == 3 {
            cell.priceButton.setTitle(String(equips[indexPath.row].price) + NSLocalizedString(" ريال سعودي", comment: ""), for: .normal)
           /* let gradientLayer = CAGradientLayer()
            gradientLayer.frame = cell.priceButton.bounds
        
            gradientLayer.colors = [UIColor(red: 23.0/255.0, green: 122.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor, UIColor(red: 13.0/255.0, green: 71.0/255.0, blue: 161.0/255.0, alpha: 1).cgColor]
        
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            cell.priceButton.layer.insertSublayer(gradientLayer, at: 0)*/
            cell.buyButton.tag = equips[indexPath.row].id
            cell.buyButton.setTitle(NSLocalizedString("أطلب الآن", comment: ""), for: .normal)
         /*   let gradientLayer2 = CAGradientLayer()
            gradientLayer2.frame = cell.buyButton.bounds
            
            gradientLayer2.colors = [UIColor(red: 23.0/255.0, green: 122.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor, UIColor(red: 13.0/255.0, green: 71.0/255.0, blue: 161.0/255.0, alpha: 1).cgColor]
            
            gradientLayer2.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer2.endPoint = CGPoint(x: 1, y: 0.5)
            cell.buyButton.layer.insertSublayer(gradientLayer2, at: 0)*/
        }else {
            cell.priceButton.alpha = 0
            cell.buyButton.alpha = 0
        }
        return cell
    }
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
