//
//  ContactUsViewController.swift
//  Machines
//
//  Created by Esslam Emad on 1/11/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import RZTransitions
import PromiseKit
import SVProgressHUD

class ContactUsViewController: UIViewController {

    @IBOutlet weak var nameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        messageTV.layer.borderColor = UIColor.darkGray.cgColor
        messageTV.layer.borderWidth = 1.5
        messageTV.layer.cornerRadius = 7.5
        messageTV.clipsToBounds = true
        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = 10.0
        if Auth.auth.language == "ar"{
            nameTF.textAlignment = .right
            emailTF.textAlignment = .right
            messageTV.textAlignment = .right
        }
        nameTF.placeholder = NSLocalizedString("الإسم", comment: "")
        nameTF.selectedTitle = NSLocalizedString("الإسم", comment: "")
        nameTF.title = NSLocalizedString("الإسم", comment: "")
        emailTF.placeholder = NSLocalizedString("البريد الإلكتروني", comment: "")
        emailTF.selectedTitle = NSLocalizedString("البريد الإلكتروني", comment: "")
        emailTF.title = NSLocalizedString("البريد الإلكتروني", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
       // self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle9"), for: .default)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func didPressSend(_ sender: Any?) {
        guard let name = nameTF.text, name != "", let email = emailTF.text, email != "", let message = messageTV.text, message != "" else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك قم بإدخال جميع البيانات.", comment: ""))
            return
        }
        SVProgressHUD.show()
        firstly {
            return API.CallApi(APIRequests.contactUs(name: name, email: email, message: message))
            }.done {
                let resp = try! JSONDecoder().decode(MessageResponse.self, from: $0)
                self.showAlert(error: false, withMessage: resp.message, completion: { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
        
    }

}
