//
//  EquipmentTableViewCell.swift
//  Machines
//
//  Created by Esslam Emad on 29/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import ImageSlideshow

class EquipmentTableViewCell: UITableViewCell {

    @IBOutlet weak var bigView: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var buyOrRentLabel: UILabel!
    @IBOutlet weak var slideShow: ImageSlideshow!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bigView.clipsToBounds = true
        bigView.layer.cornerRadius = 20.0
        priceButton.clipsToBounds = true
        priceButton.layer.cornerRadius = 10
        buyButton.clipsToBounds = true
        buyButton.layer.cornerRadius = 15
        buyOrRentLabel.clipsToBounds = true
        buyOrRentLabel.layer.cornerRadius = 20.0
      /*  let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = buyButton.bounds
        
        gradientLayer.colors = [UIColor(red: 23.0/255.0, green: 122.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor, UIColor(red: 13.0/255.0, green: 71.0/255.0, blue: 161.0/255.0, alpha: 1).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        buyButton.layer.insertSublayer(gradientLayer, at: 0)*/

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
