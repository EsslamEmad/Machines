//
//  AddOrderPopoverViewController.swift
//  Machines
//
//  Created by Esslam Emad on 22/12/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PromiseKit
import SVProgressHUD
import RZTransitions

class AddOrderPopoverViewController: UIViewController {

    var equipID: Int!
    
    @IBOutlet weak var companyTF: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTF: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTF:SkyFloatingLabelTextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = 10.0
        companyTF.placeholder = NSLocalizedString("إسم الشركة", comment: "")
        companyTF.selectedTitle = NSLocalizedString("إسم الشركة", comment: "")
        companyTF.title = NSLocalizedString("إسم الشركة", comment: "")
        nameTF.placeholder = NSLocalizedString("إسم الشخص المسؤول", comment: "")
        nameTF.selectedTitle = NSLocalizedString("إسم الشخص المسؤول", comment: "")
        nameTF.title = NSLocalizedString("إسم الشخص المسؤول", comment: "")
        emailTF.placeholder = NSLocalizedString("البريد الإلكتروني", comment: "")
        emailTF.selectedTitle = NSLocalizedString("البريد الإلكتروني", comment: "")
        emailTF.title = NSLocalizedString("البريد الإلكتروني", comment: "")
        phoneTF.placeholder = NSLocalizedString("رقم الجوال", comment: "")
        phoneTF.selectedTitle = NSLocalizedString("رقم الجوال", comment: "")
        phoneTF.title = NSLocalizedString("رقم الجوال", comment: "")
        companyTF.delegate = self
        emailTF.delegate = self
        phoneTF.delegate = self
        nameTF.delegate = self
        
    }
    

    @IBAction func didPressSend(_ sender: Any?){
        guard let company = companyTF.text, company != "", let email = emailTF.text, email.isEmail(), let phone = phoneTF.text, phone != "", let name = nameTF.text, name != "" else {
            self.showAlert(withMessage: NSLocalizedString("يرجى ادخال جميع البيانات", comment: ""))
            return
        }
        
        SVProgressHUD.show()
        firstly {
            return API.CallApi(APIRequests.addOrder(equipID: equipID, company: company, email: email, phone: phone, name: name))
            }.done {
                let resp = try! JSONDecoder().decode(MessageResponse.self, from: $0)
                self.showAlert(error: false, withMessage: resp.message, completion: {(UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally{
                SVProgressHUD.dismiss()
        }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let constraint = NSLayoutConstraint(item: sendButton, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0)
        scrollView.addConstraint(constraint)
    }

}
