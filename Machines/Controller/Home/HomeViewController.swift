//
//  HomeViewController.swift
//  Machines
//
//  Created by Esslam Emad on 29/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions
import SideMenu

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.transitioningDelegate = RZTransitionsManager.shared()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
      //  self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle9"), for: .default)
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func didPressBuy(_ sender: Any?) {
        performSegue(withIdentifier: "show equips", sender: true)
    }
    
    /*@IBAction func didPressRent(_ sender: Any?) {
        performSegue(withIdentifier: "show equips", sender: false)
    }*/
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show equips" {
            let destination = segue.destination as! EquipmentsViewController
            destination.buy = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
