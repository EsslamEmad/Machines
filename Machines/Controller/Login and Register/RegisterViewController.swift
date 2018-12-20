//
//  RegisterViewController.swift
//  Machines
//
//  Created by Esslam Emad on 28/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD
import RZTransitions
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var nameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var confirmPasswordTF: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()

        registerView.layer.cornerRadius = 15.0
        registerButton.layer.cornerRadius = 15.0
        registerButton.clipsToBounds = true
        registerView.clipsToBounds = true
        profilePicture.layer.cornerRadius = 64.0
        profilePicture.clipsToBounds = true
        if Auth.auth.language == "ar"{
            nameTF.textAlignment = .right
            emailTF.textAlignment = .right
            passwordTF.textAlignment = .right
            confirmPasswordTF.textAlignment = .right
            phoneTF.textAlignment = .right
            backButton.setImage(UIImage(named: "arrow-point-to-right"), for: .normal)
        }
        registerView.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 15.0, scale: true)
        
    }
    

    @IBAction func didPressRegister(_ sender: Any?) {
        guard let name = nameTF.text, name != "", let email = emailTF.text, email.isEmail(), let phone = phoneTF.text, phone != "", let password = passwordTF.text, password != "", ImagePicked else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك أدخل جميع بياناتك.", comment: ""))
            return
        }
        guard passwordTF.text == confirmPasswordTF.text else {
            self.showAlert(withMessage: NSLocalizedString("كلمة المرور غير متطابقة", comment: ""))
            return
        }
        var user = User()
        user.name = name
        user.email = email
        user.password = password
        user.phone = phone
        SVProgressHUD.show()
        firstly {
            return API.CallApi(APIRequests.upload(image: profilePicture.image, file: nil))
            }.done {
                let resp = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                user.photo = resp.image
                firstly {
                    return API.CallApi(APIRequests.register(user: user))
                    }.done {
                        Auth.auth.user = try! JSONDecoder().decode(User.self, from: $0)
                        self.showAlert(error: false, withMessage: NSLocalizedString("تم تسجيل الحساب بنجاح.", comment: ""), completion: { (UIAlertAction) in  self.performSegue(withIdentifier: "Back To Main", sender: nil) })
                    }.catch {
                        self.showAlert(withMessage: $0.localizedDescription)
                    }.finally {
                        SVProgressHUD.dismiss()
                }
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
                SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func didPressBack(_ sender: Any?) {
       // performSegue(withIdentifier: "unwind", sender: nil)
    }
    
    @IBAction func didPressEye(_ sender: Any){
        passwordTF.togglePasswordVisibility()
    }
    
    @IBAction func didPressEye2(_ sender: Any){
        confirmPasswordTF.togglePasswordVisibility()
    }
    
    
    //Mark: Image Picker
    
    @IBAction func PickImage(recognizer: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("اختر طريقة رفع الصورة.", comment: ""), preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("الكاميرا", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى الكاميرا الخاصة بك", comment: ""))
            }
        })
        let photoAction = UIAlertAction(title: NSLocalizedString("مكتبة الصور", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى مكتبة الصور الخاصة بك", comment: ""))
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    var ImagePicked = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
            profilePicture.image = selectedImage
            profilePicture.contentMode = .scaleAspectFill
            profilePicture.clipsToBounds = true
            ImagePicked = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    /*override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }*/

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
