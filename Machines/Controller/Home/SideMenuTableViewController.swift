//
//  SideMenuTableViewController.swift
//  Machines
//
//  Created by Esslam Emad on 31/10/18.
//  Copyright © 2018 Alyom Apps. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        profilePicture.layer.cornerRadius = 50.0
        profilePicture.clipsToBounds = true
        
      //  guard Auth.auth.user != nil else {
           // profilePicture.image = UIImage(named: "AppIcon")
        //    return
      //  }
     /*   if let imgurl = URL(string: Auth.auth.user!.photo){
            profilePicture.kf.indicatorType = .activity
            profilePicture.kf.setImage(with: imgurl)
            //profilePicture.layer.cornerRadius = 50.0
            //profilePicture.clipsToBounds = true
        }*/
        nameLabel.text = NSLocalizedString("مؤسسة الآليات العربية", comment: "")
     //   emailLabel.text = Auth.auth.user!.email
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show equips list" {
            let destination = segue.destination as! EquipmentsListTableViewController
            destination.state = (sender as! Int)
        }
    }

    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            performSegue(withIdentifier: "show profile", sender: nil)
        case 2:
            performSegue(withIdentifier: "show equips list", sender: 1)
        case 3:
            performSegue(withIdentifier: "show equips list", sender: 2)
        case 4:
            performSegue(withIdentifier: "show equips list", sender: 3)
       /* case 5:
            performSegue(withIdentifier: "show notifications", sender: nil)*/
        case 5:
            performSegue(withIdentifier: "Login", sender: nil)
        case 6:
            self.dismiss(animated: true, completion: nil)
            if L102Language.currentAppleLanguage() == "en" {
                L102Language.setAppleLAnguageTo(lang: "ar")
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                L102Language.setAppleLAnguageTo(lang: "en")
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
            Auth.auth.language = L102Language.currentAppleLanguage()
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
            }) { (finished) -> Void in
            }
            /*
            let alert = UIAlertController(title: NSLocalizedString("اللغة", comment: ""), message: NSLocalizedString("إختر اللغة!", comment: ""), preferredStyle: .actionSheet)
            let eng = UIAlertAction(title: "English", style: .default, handler: {(UIAlertAction) -> Void in
                guard Language.language != .english else{
                    return
                }
                Language.language = .english
                self.showAlert(error: false, withMessage: "Please, restart the application to change the language!", completion: nil)
            })
            let ar = UIAlertAction(title: "عربي", style: .default, handler: {(UIAlertAction) -> Void in
                guard Language.language != .arabic else {
                    return
                }
                Language.language = .arabic
                self.showAlert(error: false, withMessage: "من فضلك، أعد تشغيل التطبيق لتغيير اللغة", completion: nil)
            })
            let cancel = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
            alert.addAction(eng)
            alert.addAction(ar)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
 */
        case 7:
            performSegue(withIdentifier: "show contact us", sender: nil)
        case 8:
            performSegue(withIdentifier: "show about us", sender: nil)
        case 9:
            let alert = UIAlertController(title: NSLocalizedString("تسجيل الخروج", comment: ""), message: NSLocalizedString("هل أنت متأكد من رغبتك في تسجيل الخروج؟", comment: ""), preferredStyle: .alert)
            let yesAction = UIAlertAction(title: NSLocalizedString("نعم", comment: ""), style: .default, handler: {(UIAlertAction) in
                
                Auth.auth.user = nil
                //self.dismiss(animated: true, completion: { self.performLoginSegue()})
                self.performSegue(withIdentifier: "Back", sender: nil)
            })
            let noAction = UIAlertAction(title: NSLocalizedString("لا", comment: ""), style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            present(alert, animated:  true, completion: nil)
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let signedIn = Auth.auth.user == nil ? false : true
        let signedIn = false
        switch indexPath.row {
        case 0: return 200
        case 1: return signedIn ? 60: 0
        case 2: return signedIn ? 60: 0
        case 3: return signedIn ? 60: 0
        case 4: return signedIn ? 60: 0
        case 5: return signedIn ? 0: 0
        case 6: return 60
        case 7: return 60
        case 8: return 60
        case 9: return signedIn ? 60: 0
        default: return 0
        }
    }

    func performLoginSegue(animated: Bool = true) {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        vc.view.frame = rootViewController.view.frame
        vc.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            
            window.rootViewController = vc
        })
    }

}
