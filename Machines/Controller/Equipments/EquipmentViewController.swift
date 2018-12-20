//
//  EquipmentViewController.swift
//  Machines
//
//  Created by Esslam Emad on 29/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions
import SVProgressHUD
import PromiseKit
import ImageSlideshow

class EquipmentViewController: UIViewController {

    var id: Int!
    var isLiked = false
    var inputs = [InputSource]()
    var formType: Int!
    var equip: Equipment?
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var workHoursLabel: UILabel!
    @IBOutlet weak var generalStateLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var liftCapacityLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var autoLiftLabel: UILabel!
    @IBOutlet weak var remoteControlLabel: UILabel!
    @IBOutlet weak var overWeightLabel: UILabel!
    @IBOutlet weak var bearWeightLabel: UILabel!
    @IBOutlet weak var speed2Label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15.0
        buyButton.clipsToBounds = true
        buyButton.layer.cornerRadius = 15.0
        priceButton.clipsToBounds = true
        priceButton.layer.cornerRadius = 10.0
        getEquipment()
        if isLiked {
             likeButton.setImage(UIImage(named: "faHeartO-1"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
       /* let gradientLayer = CAGradientLayer()
        gradientLayer.frame = buyButton.bounds
        gradientLayer.colors = [UIColor(red: 23.0/255.0, green: 122.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor, UIColor(red: 13.0/255.0, green: 71.0/255.0, blue: 161.0/255.0, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        buyButton.layer.insertSublayer(gradientLayer, at: 0)*/
    }
    
    @IBAction func didPressBuy(_ sender: Any) {
        guard Auth.auth.user != nil else {
            let alert = UIAlertController(title: NSLocalizedString("تسجيل الدخول", comment: ""), message: NSLocalizedString("قم بتسجيل الدخول أولا لتتمكن من شراء أو إيجار المنتج", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("حسناً", comment: ""), style: .default, handler: {(UIAlertAction) in
                self.performSegue(withIdentifier: "Login", sender: nil)
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            return
        }
        var segueID: String!
        switch formType {
        case 1:
            segueID = "rent equip"
        case 2:
            segueID = "rent equip"
        default:
            segueID = "buy equip"
        }
        performSegue(withIdentifier: segueID, sender: nil)
    }
    
    @IBAction func didPressLike(_ sender: Any) {
        guard Auth.auth.user != nil else {
            let alert = UIAlertController(title: NSLocalizedString("تسجيل الدخول", comment: ""), message: NSLocalizedString("قم بتسجيل الدخول أولاً لتتمكن من إضافة المنتج إلى المفضلة", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("حسناً", comment: ""), style: .default, handler: {(UIAlertAction) in
                self.performSegue(withIdentifier: "Login", sender: nil)
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            return
        }
        SVProgressHUD.show()
        if !isLiked{
        likeButton.setImage(UIImage(named: "faHeartO-1"), for: .normal)
        firstly{
            return API.CallApi(APIRequests.addToWishlist(equipID: id))
            }.done {
                let resp = try! JSONDecoder().decode(MessageResponse.self, from: $0)
                self.showAlert(error: false, withMessage: resp.message, completion: nil)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                self.isLiked = true
        }
        } else {
            likeButton.setImage(UIImage(named: "faHeartO"), for: .normal)
            firstly{
                return API.CallApi(APIRequests.removeFromWishlist(equipID: id))
                }.done {
                    let resp = try! JSONDecoder().decode(MessageResponse.self, from: $0)
                    self.showAlert(error: false, withMessage: resp.message, completion: nil)
                }.catch {
                    self.showAlert(withMessage: $0.localizedDescription)
                }.finally {
                    SVProgressHUD.dismiss()
                    self.isLiked = false
            }
        }
    }
    
    func getEquipment() {
        SVProgressHUD.show()
        buyButton.isEnabled = false
        firstly {
            return API.CallApi(APIRequests.getEquip(id: id))
            }.done {
                let equipment = try! JSONDecoder().decode(Equipment.self, from: $0)
                self.equip = equipment
                self.title = equipment.title
                for photo in equipment.photos{
                    if let imgurl = URL(string: photo){
                        self.inputs.append(KingfisherSource(url: imgurl))
                    }
                }
                self.slideShow.setImageInputs(self.inputs)
                self.slideShow.slideshowInterval = 5.0
                self.slideShow.contentScaleMode = .scaleAspectFill
                self.slideShow.clipsToBounds = true
                self.priceButton.setTitle(String(equipment.price) + NSLocalizedString(" ريال سعودي", comment: ""), for: .normal)
                self.workHoursLabel.text = String(equipment.workingHours) + NSLocalizedString(" ساعة", comment: "")
                self.generalStateLabel.text = equipment.state
                self.weightLabel.text = String(equipment.weight) + NSLocalizedString(" طن", comment: "")
                self.liftCapacityLabel.text = String(equipment.capacity) + NSLocalizedString(" طن", comment: "")
                self.speedLabel.text = String(equipment.speed) + NSLocalizedString(" كم/ساعة", comment: "")
                self.autoLiftLabel.text = equipment.autoLift == 1 ? NSLocalizedString("يوجد", comment: "") : NSLocalizedString("لا يوجد", comment: "")
                self.remoteControlLabel.text = equipment.remoteControl == 1 ? NSLocalizedString("يوجد", comment: "") : NSLocalizedString("لا يوجد", comment: "")
                self.overWeightLabel.text = equipment.overWeight == 1 ? NSLocalizedString("يوجد", comment: "") : NSLocalizedString("لا يوجد", comment: "")
                self.bearWeightLabel.text = equipment.bearWeight == 1 ? NSLocalizedString("يوجد", comment: "") : NSLocalizedString("لا يوجد", comment: "")
                self.speed2Label.text = equipment.speedDesc == 1 ? NSLocalizedString("يوجد", comment: "") : NSLocalizedString("لا يوجد", comment: "")
              /*  let gradientLayer = CAGradientLayer()
                gradientLayer.frame = self.priceButton.bounds
                gradientLayer.colors = [UIColor(red: 23.0/255.0, green: 122.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor, UIColor(red: 13.0/255.0, green: 71.0/255.0, blue: 161.0/255.0, alpha: 1).cgColor]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
                self.priceButton.layer.insertSublayer(gradientLayer, at: 0)*/
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                self.buyButton.isEnabled = true
        }
        
    }
    
    @IBAction func unwindFromLogin(_ unwindSegue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "buy equip"{
            let destination = segue.destination as! AddOrderViewController
            destination.id = id
        } else if segue.identifier == "rent equip" {
            let destination = segue.destination as! RentFormTableViewController
            destination.formType = formType
            destination.equip = equip
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
