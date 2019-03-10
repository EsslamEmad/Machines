//
//  CategoryViewController.swift
//  Machines
//
//  Created by Esslam Emad on 20/12/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import RZTransitions

class CategoryViewController: UIViewController {

    var category: Category!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var rentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        categoryView.clipsToBounds = true
        categoryView.layer.cornerRadius = 15.0
        categoryName.text = category.name
        switch category.id {
        case 1:
            categoryImage.image = UIImage(named: "cat2")
        case 2:
            categoryImage.image = UIImage(named: "cat1")
        case 3:
            categoryImage.image = UIImage(named: "cat3")
        case 4:
            categoryImage.image = UIImage(named: "cat4")
        default:
            categoryImage.image = UIImage(named: "cat5")
        }
        
        buyButton.clipsToBounds = true
        buyButton.layer.cornerRadius = 10.0
        rentButton.clipsToBounds = true
        rentButton.layer.cornerRadius = 10.0
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show buy" {
            let destination = segue.destination as! EquipmentsViewController
            destination.category = category
        }else if segue.identifier == "show rent" {
            let destination = segue.destination as! RentFormTableViewController
            destination.category = category
        }
    }
  

}
