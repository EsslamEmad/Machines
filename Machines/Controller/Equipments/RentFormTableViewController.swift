//
//  RentFormTableViewController.swift
//  Machines
//
//  Created by Esslam Emad on 15/12/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
import PromiseKit
import RZTransitions
import Localize_Swift
import IQKeyboardManagerSwift

class RentFormTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var equip: Equipment!
    var category: Category!
    var formType: Int!
    var rentOptions = [WightPeriodOptions]()
    var index: Int!
    var rentForm = RentForm()
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryPhoto: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var innerRadiorButton: UIButton!
    @IBOutlet weak var outterRadioButton: UIButton!
    @IBOutlet weak var fromTF: SkyFloatingLabelTextField!
    @IBOutlet weak var toTF: SkyFloatingLabelTextField!
    @IBOutlet weak var detailsTF: SkyFloatingLabelTextField!
    @IBOutlet weak var weightTF: SkyFloatingLabelTextField!
    @IBOutlet weak var periodTF: SkyFloatingLabelTextField!
    @IBOutlet weak var companyNameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var locationTF: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTF: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //subscribeToKeyboardNotifications()
        self.transitioningDelegate = RZTransitionsManager.shared()
        initializeToolbar()
        innerRadiorButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        outterRadioButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
       // innerRadiorButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
      //  outterRadioButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = 15.0
        if category.formType == 2 {
            innerCheck(nil)
        }
        categoryView.clipsToBounds = true
        categoryView.layer.cornerRadius = 10
        switch category.id {
        case 1:
            categoryPhoto.image = UIImage(named: "cat2")
        case 2:
            categoryPhoto.image = UIImage(named: "cat1")
        case 3:
            categoryPhoto.image = UIImage(named: "cat3")
        case 4:
            categoryPhoto.image = UIImage(named: "cat4")
        default:
            categoryPhoto.image = UIImage(named: "cat5")
        }
            categoryName.text = category.name
        
        
        if category.formType == 1{
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getRentOptions(categoryID: category.id))
            }.done {
                self.rentOptions = try! JSONDecoder().decode([WightPeriodOptions].self, from: $0)
                
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
        }
        companyNameTF.placeholder = NSLocalizedString("إسم الشركة", comment: "").localized()
        companyNameTF.selectedTitle = NSLocalizedString("إسم الشركة", comment: "").localized()
        companyNameTF.title = NSLocalizedString("إسم الشركة", comment: "").localized()
        nameTF.placeholder = NSLocalizedString("إسم الشخص المسؤول", comment: "")
        nameTF.selectedTitle = NSLocalizedString("إسم الشخص المسؤول", comment: "")
        nameTF.title = NSLocalizedString("إسم الشخص المسؤول", comment: "")
        emailTF.placeholder = NSLocalizedString("البريد الإلكتروني", comment: "")
        emailTF.selectedTitle = NSLocalizedString("البريد الإلكتروني", comment: "")
        emailTF.title = NSLocalizedString("البريد الإلكتروني", comment: "")
        phoneTF.placeholder = NSLocalizedString("رقم الجوال", comment: "")
        phoneTF.selectedTitle = NSLocalizedString("رقم الجوال", comment: "")
        phoneTF.title = NSLocalizedString("رقم الجوال", comment: "")
        locationTF.placeholder = NSLocalizedString("موقع العمل", comment: "")
        locationTF.selectedTitle = NSLocalizedString("موقع العمل", comment: "")
        locationTF.title = NSLocalizedString("موقع العمل", comment: "")
        fromTF.placeholder = NSLocalizedString("من:", comment: "")
        fromTF.selectedTitle = NSLocalizedString("من:", comment: "")
        fromTF.title = NSLocalizedString("من:", comment: "")
        toTF.placeholder = NSLocalizedString("إلى:", comment: "")
        toTF.selectedTitle = NSLocalizedString("إلى:", comment: "")
        toTF.title = NSLocalizedString("إلى:", comment: "")
        detailsTF.placeholder = NSLocalizedString("التفاصيل", comment: "")
        detailsTF.selectedTitle = NSLocalizedString("التفاصيل", comment: "")
        detailsTF.title = NSLocalizedString("التفاصيل", comment: "")
        weightTF.placeholder = NSLocalizedString("الطن", comment: "")
        weightTF.selectedTitle = NSLocalizedString("الطن", comment: "")
        weightTF.title = NSLocalizedString("الطن", comment: "")
        periodTF.placeholder = NSLocalizedString("المدة المتاحة", comment: "")
        periodTF.selectedTitle = NSLocalizedString("المدة المتاحة", comment: "")
        periodTF.title = NSLocalizedString("المدة المتاحة", comment: "")
        companyNameTF.delegate = self
        nameTF.delegate = self
        emailTF.delegate = self
        phoneTF.delegate = self
        locationTF.delegate = self
        fromTF.delegate = self
        toTF.delegate = self
        detailsTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle9"), for: .default)
        self.navigationController?.isNavigationBarHidden = false
       // IQKeyboardManager.shared.keyboardDistanceFromTextField = 10.0
    }

    override func viewDidAppear(_ animated: Bool) {
        //subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       // unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func didPressSend(_ sender: Any) {
        guard let name = companyNameTF.text, name != "", let location = locationTF.text, location != "", let email = emailTF.text, let phone = phoneTF.text, phone != "", let personName = nameTF.text, personName != "" else{
            self.showAlert(withMessage: NSLocalizedString("من فضلك ادخل جميع بياناتك", comment: ""))
            return
        }
        guard email.isEmail() else {
            self.showAlert(withMessage: NSLocalizedString("البريد الالكتروني غير صحيح", comment: ""))
            return
        }
        if category.formType == 1 {
            guard rentForm.weightID != nil, rentForm.periodID != nil else {
                self.showAlert(withMessage: NSLocalizedString("من فضلك ادخل جميع البيانات", comment: ""))
                return
            }
        }
        else if category.formType == 2, rentForm.tour == 2{
            guard let from = fromTF.text, from != "", let to = toTF.text, to != "", let details = detailsTF.text, details != "" else {
                self.showAlert(withMessage: NSLocalizedString("من فضلك ادخل جميع البيانات", comment: ""))
                return
            }
            rentForm.from = from
            rentForm.to = to
            rentForm.details = details
        }
        else if category.formType == 2, rentForm.tour == 1{
            guard let details = detailsTF.text, details != "" else {
                self.showAlert(withMessage: NSLocalizedString("من فضلك ادخل جميع البيانات", comment: ""))
                return
            }
            rentForm.from = " "
            rentForm.to = " "
            rentForm.details = details
        }
        rentForm.companyName = name
        rentForm.location = location
        rentForm.phone = phone
        rentForm.email = email
        rentForm.catID = category.id
        rentForm.name = personName
        // rentForm.userID = Auth.auth.user!.id
        //rentForm.equipID = equip.id
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.rentEquip(rentForm: rentForm))
            }.done {
                let resp = try! JSONDecoder().decode(MessageResponse.self, from: $0)
                self.showAlert(error: false, withMessage: resp.message, completion: {(UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func innerCheck(_ sender: Any?) {
        rentForm.tour = 1
        innerRadiorButton.setImage(UIImage(named: "rounded-black-square-shape"), for: .normal)
        outterRadioButton.setImage(UIImage(named: "blank-square"), for: .normal)
        fromTF.alpha = 0
        toTF.alpha = 0
    }
    
    @IBAction func outerCheck(_ sender: Any?) {
        rentForm.tour = 2
        outterRadioButton.setImage(UIImage(named: "rounded-black-square-shape"), for: .normal)
        innerRadiorButton.setImage(UIImage(named: "blank-square"), for: .normal)
        fromTF.alpha = 1
        toTF.alpha = 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 136
        case 1:
            return category.formType == 2 ? 162 : 0
        case 2:
            return category.formType == 1 ? 145 : 0
        default:
            return 440
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    private let weightPicker = UIPickerView()
    private var inputAccessoryBar: UIToolbar!
    private var periodPicker = UIPickerView()
    
    private func initializePickers() {
        weightPicker.delegate = self
        weightPicker.dataSource = self
        periodPicker.delegate = self
        periodPicker.dataSource = self
        weightTF.inputView = weightPicker
        weightTF.inputAccessoryView = inputAccessoryBar
        periodTF.inputView = periodPicker
        periodTF.inputAccessoryView = inputAccessoryBar
        //sexTF.text = user.gender == 1 ? NSLocalizedString("ذكر", comment: "") : NSLocalizedString("أنثى", comment: "")
       // voice.gender = user.gender
    }
    private func initializeToolbar() {
        inputAccessoryBar = UIToolbar(frame: CGRect(x: 0, y:0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(title: NSLocalizedString("تم", comment: ""), style: .done, target: self, action: #selector(dismissPicker))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font:  UIFont(name: "BahijTheSansArabic-Plain", size: 13)!, NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font:  UIFont(name: "BahijTheSansArabic-Plain", size: 13)!, NSAttributedString.Key.foregroundColor: UIColor.blue], for: .highlighted)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        inputAccessoryBar.items = [flexibleSpace, doneButton]
        initializePickers()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == weightPicker, rentOptions.count > 0{
            return rentOptions.count + 1
        } else if pickerView == periodPicker, index != nil {
            return rentOptions[index].periods.count + 1
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row != 0 else {
            return ""
        }
        if pickerView == weightPicker{
            
            return rentOptions[row - 1].weightName
        }
        else {
            return rentOptions[index].periods[row - 1].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard rentOptions.count > 0 else { return }
        guard row != 0 else { return }
        if pickerView == weightPicker {
            rentForm.weightID = rentOptions[row - 1].weightID
            index = row - 1
            weightTF.text = rentOptions[row - 1 ].weightName
        } else if index != nil{
            rentForm.periodID = rentOptions[index].periods[row - 1].id
            periodTF.text = rentOptions[index].periods[row - 1].name
        }
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
}
