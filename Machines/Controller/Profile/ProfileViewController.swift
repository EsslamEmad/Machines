//
//  ProfileViewController.swift
//  Machines
//
//  Created by Esslam Emad on 1/11/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions

class ProfileViewController: UIViewController {

    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var mainNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = RZTransitionsManager.shared()
        
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
      //  self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle9"), for: .default)
        self.navigationController?.isNavigationBarHidden = false
        profilePicture.layer.cornerRadius = 75
        profilePicture.clipsToBounds = true
        let user = Auth.auth.user!
        mainNameLabel.text = user.name
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        if let imgurl = URL(string: user.photo){
            profilePicture.kf.indicatorType = .activity
            profilePicture.kf.setImage(with: imgurl)
        }
       /* let gradientLayer = CAGradientLayer()
        gradientLayer.frame = editButton.bounds
        
        gradientLayer.colors = [UIColor(red: 23.0/255.0, green: 122.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor, UIColor(red: 13.0/255.0, green: 71.0/255.0, blue: 161.0/255.0, alpha: 1).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        editButton.layer.insertSublayer(gradientLayer, at: 0)*/
        
        editButton.layer.cornerRadius = 15.0
        editButton.clipsToBounds = true
        containerView.layer.cornerRadius = 5.0
        containerView.clipsToBounds = true
        containerView.dropShadow(color: .black, opacity: 0.4, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
    }

    @IBAction func didPressEdit(_ sender: Any) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

}


extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
