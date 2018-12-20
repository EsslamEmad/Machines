//
//  AboutUsViewController.swift
//  Machines
//
//  Created by Esslam Emad on 1/11/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import RZTransitions

class AboutUsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
       // self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle9"), for: .default)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        contentView.layer.cornerRadius = 10.0
        contentView.clipsToBounds = true
        contentView.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true)
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getPage(id: 1))
            }.done {
                let page = try! JSONDecoder().decode(Page.self, from: $0)
                self.contentLabel.text = page.content
                self.titleLabel.text = page.title
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }

}
