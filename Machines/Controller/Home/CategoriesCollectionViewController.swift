//
//  CategoriesCollectionViewController.swift
//  Machines
//
//  Created by Esslam Emad on 13/12/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import RZTransitions
import SideMenu

class CategoriesCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitioningDelegate = RZTransitionsManager.shared()
        
        //if Auth.auth.categories == nil {
            SVProgressHUD.show()
            firstly{
                return API.CallApi(APIRequests.getCategories)
                }.done {
                    Auth.auth.categories = try! JSONDecoder().decode([Category].self, from: $0)
                    self.collectionView.reloadData()
                }.catch {
                    self.showAlert(withMessage: $0.localizedDescription)
                }.finally {
                    SVProgressHUD.dismiss()
            }
       // }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
       // self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle9"), for: .default)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func didPressSideMenu(_ sender: Any?) {
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "SideMenu") as! UISideMenuNavigationController
        //sideMenu.sideMenuManager.menuPresentMode = .viewSlideInOut
        //sideMenu.sideMenuManager.menuAnimationFadeStrength = 0.75
        
        if Auth.auth.language == "en"{
            sideMenu.leftSide = true
        }
        present(sideMenu, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (Auth.auth.categories?.count ?? 0) + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! CategoryCollectionViewCell
    
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 10.0
        guard indexPath.row != (Auth.auth.categories?.count ?? 0) else {
            cell.label.text = ""
            cell.photo.image = UIImage(named: "black")
            return cell
        }
        let cats = Auth.auth.categories!
        cell.label.text = cats[indexPath.row].name
        switch cats[indexPath.row].id {
        case 1:
            cell.photo.image = UIImage(named: "cat2")
        case 2:
            cell.photo.image = UIImage(named: "cat1")
        case 3:
            cell.photo.image = UIImage(named: "cat3")
        case 4:
            cell.photo.image = UIImage(named: "cat4")
        default:
            cell.photo.image = UIImage(named: "cat5")
        }
        //cell.photo.image = UIImage(named: "cat\(indexPath.row + 1)")
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row != (Auth.auth.categories?.count ?? 0) else {
            performSegue(withIdentifier: "show about us", sender: nil)
            return
        }
        performSegue(withIdentifier: "show category", sender: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 2 - 30, height: view.frame.size.width / 2 - 30)
    }
    
    //navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show equipments" {
            let destination = segue.destination as! EquipmentsViewController
            destination.buy = false
            //destination.catID = Auth.auth.categories![(sender as! Int)].id
            //destination.formType = Auth.auth.categories![(sender as! Int)].formType
        } else if segue.identifier == "show category"{
            let destination = segue.destination as! CategoryViewController
            destination.category = Auth.auth.categories![(sender as! Int)]
        }
    }
}
