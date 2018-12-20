//
//  AddOrderViewController.swift
//  Machines
//
//  Created by Esslam Emad on 31/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
import PromiseKit
import RZTransitions

class AddOrderViewController: UIViewController {

    var id: Int!
    
    @IBOutlet weak var titleTF: SkyFloatingLabelTextField!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var addOrderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        messageTV.layer.borderColor = UIColor.darkGray.cgColor
        messageTV.layer.borderWidth = 1.5
        messageTV.layer.cornerRadius = 7.5
        messageTV.clipsToBounds = true
        addOrderButton.clipsToBounds = true
        addOrderButton.layer.cornerRadius = 10.0
        if Auth.auth.language == "ar"{
            titleTF.textAlignment = .right
            messageTV.textAlignment = .right
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
       // self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle9"), for: .default)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func didPressAdd(_ sender: Any?){
        guard let title = titleTF.text, title != "", let message = messageTV.text, message != "" else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك قم بإدخال عنوان و نص الرسالة!", comment: ""))
            return
        }
        SVProgressHUD.show()
        firstly {
            return API.CallApi(APIRequests.addOrder(equipID: id, userID: Auth.auth.user!.id, title: title, details: message))
            }.done {
                let resp = try! JSONDecoder().decode(MessageResponse.self, from: $0)
                self.showAlert(error: false, withMessage: resp.message, completion: {(UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                })
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
