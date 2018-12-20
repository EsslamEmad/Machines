//
//  LoginViewController.swift
//  Machines
//
//  Created by Esslam Emad on 25/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import RZTransitions
import SkyFloatingLabelTextField


class LoginViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginView.layer.cornerRadius = 15.0
        signInButton.layer.cornerRadius = 15.0
        loginView.clipsToBounds = true
        loginView.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 15.0, scale: true)
        signInButton.clipsToBounds = true
        self.transitioningDelegate = RZTransitionsManager.shared()
        if Auth.auth.language == "ar"{
            emailTF.textAlignment = .right
            passwordTF.textAlignment = .right
            backButton.setImage(UIImage(named: "right-arrow-3"), for: .normal)
        }
    }
    
    @IBAction func didPressSignIn(_ sender: Any?) {
        guard let email = emailTF.text, email.isEmail(), let password = passwordTF.text, password != "" else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك أدخل بريدك الإلكتروني و كلمة المرور الخاصة بك.", comment: ""))
            return
        }
        SVProgressHUD.show()
        firstly {
            return API.CallApi(APIRequests.login(email: email, password: password))
            }.done {
                Auth.auth.user = try! JSONDecoder().decode(User.self, from: $0)
                //self.performMainSegue()
                self.performSegue(withIdentifier: "Back To Main", sender: nil)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func didPressForgotPassword(_ sender: Any?) {
        let alert = UIAlertController(title: "", message: NSLocalizedString("من فضلك أدخل بريدك الإلكتروني..", comment: ""), preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("البريد الإلكتروني", comment: "")
        }
        let resetPasswordAction = UIAlertAction(title: NSLocalizedString("إستعادة كلمة المرور", comment: ""), style: .default, handler: { (UIAlertAction) in
            if let textField = alert.textFields?.first{
                guard let email = textField.text, email != "", email.isEmail() else {
                    self.showAlert(error: true, withMessage: NSLocalizedString("من فضلك أدخل بريدك الإلكتروني!", comment: ""), completion: nil)
                    return
                }
                SVProgressHUD.show()
                firstly{
                    return API.CallApi(APIRequests.forgotPassword(email: textField.text!))
                    }.done {
                        let resp = try! JSONDecoder().decode(MessageResponse.self, from: $0)
                        self.showAlert(error: false, withMessage: resp.message, completion: nil)
                    }.catch {
                        self.showAlert(withMessage: $0.localizedDescription)
                    }.finally {
                        SVProgressHUD.dismiss()
                }
                
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
        alert.addAction(resetPasswordAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressNewAccount(_ sender: Any?) {
        
    }
    
    @IBAction func didPressEye(_ sender: Any){
        passwordTF.togglePasswordVisibility()
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    func performMainSegue(animated: Bool = true){
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        })
    }
    
}



extension String {
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    
}


extension UITextField {
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry
        
        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            deleteBackward()
            
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }
        
        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
