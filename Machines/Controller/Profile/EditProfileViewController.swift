//
//  EditProfileViewController.swift
//  Machines
//
//  Created by Esslam Emad on 1/11/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import PromiseKit
import SVProgressHUD
import RZTransitions

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var nameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var confirmPaswwordTf: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var phoneTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    var user = Auth.auth.user!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        nameTF.text = user.name
        emailTF.text = user.email
        phoneTF.text = user.phone
        if let imgurl = URL(string: user.photo){
            profilePicture.kf.indicatorType = .activity
            profilePicture.kf.setImage(with: imgurl)
        }
        profilePicture.layer.cornerRadius = 64.0
        profilePicture.clipsToBounds = true
        if Auth.auth.language == "ar"{
            nameTF.textAlignment = .right
            emailTF.textAlignment = .right
            passwordTF.textAlignment = .right
            confirmPaswwordTf.textAlignment = .right
            phoneTF.textAlignment = .right
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
      //  self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle9"), for: .default)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewDidLayoutSubviews() {
        
        /*let gradientLayer = CAGradientLayer()
        gradientLayer.frame = saveButton.bounds
        
        gradientLayer.colors = [UIColor(red: 23.0/255.0, green: 122.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor, UIColor(red: 13.0/255.0, green: 71.0/255.0, blue: 161.0/255.0, alpha: 1).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        saveButton.layer.insertSublayer(gradientLayer, at: 0)*/
        
        saveButton.layer.cornerRadius = 15.0
        saveButton.clipsToBounds = true
        containerView.layer.cornerRadius = 5.0
        containerView.clipsToBounds = true
        containerView.dropShadow(color: .black, opacity: 0.4, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    @IBAction func didPressSave(_ sender: Any) {
        user = User()
        guard passwordTF.text == confirmPaswwordTf.text else {
            self.showAlert(withMessage: NSLocalizedString("كلمة المرور غير متطابقة.", comment: ""))
            return
        }
        if user.password != passwordTF.text, passwordTF.text != ""{
            user.password = passwordTF.text
        }
        guard nameTF.text != "" else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك أدخل إسم المستخدم", comment: ""))
            return
        }
        user.name = nameTF.text
        guard emailTF.text != "" else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك أدخل بريدك الإلكتروني", comment: ""))
            return
        }
        user.email = emailTF.text
        guard phoneTF.text != "" else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك أدخل رقم الجوال الخاص بك", comment: ""))
            return
        }
        user.phone = phoneTF.text
        user.id = Auth.auth.user!.id
        SVProgressHUD.show()
        
        if ImagePicked{
            firstly {
                return API.CallApi(APIRequests.upload(image: profilePicture.image, file: nil))
                }.done {
                    let resp = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                    self.user.photo = resp.image
                    self.save()
                }.catch {
                    self.showAlert(withMessage: $0.localizedDescription)
                    SVProgressHUD.dismiss()
            }
        }else {
            save()
        }
    }
    
    @IBAction func didPressEye(_ sender: Any){
        passwordTF.togglePasswordVisibility()
    }
    
    @IBAction func didPressEye2(_ sender: Any){
        confirmPaswwordTf.togglePasswordVisibility()
    }
    
    func save(){
        firstly {
            return API.CallApi(APIRequests.editUser(variables: user))
            }.done {
                Auth.auth.user = try! JSONDecoder().decode(User.self, from: $0)
                self.showAlert(error: false, withMessage: NSLocalizedString("تم حفظ بياناتك بنجاح.", comment: ""), completion: { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
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
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    

}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
