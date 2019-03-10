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
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var contentView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = NSLocalizedString("مؤسسة الآليات العربية", comment: "")
        self.transitioningDelegate = RZTransitionsManager.shared()
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
       // self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "rectangle9"), for: .default)
        self.navigationController?.isNavigationBarHidden = false
    }
    var done = false
    override func viewDidLayoutSubviews() {
        guard !done else {
            return
        }
        contentView.layer.cornerRadius = 10.0
        contentView.clipsToBounds = true
       //contentView.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 1, scale: true)
        SVProgressHUD.show()
        firstly{
            return API.CallApi(APIRequests.getPage(id: 1))
            }.done {
                let page = try! JSONDecoder().decode(Page.self, from: $0)
                let attstr = page.content.html2AttributedString
                self.contentLabel.attributedText = page.content.html2AttributedString
                self.titleLabel.text = page.title
                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: page.content, options: [], range: NSRange(location: 0, length: page.content.utf16.count))
                self.done = true
                for match in matches {
                    guard let range = Range(match.range, in: page.content) else { continue }
                    let url = page.content[range]
                    let foundRange = attstr!.mutableString.range(of: String(page.content[range]))
                    if foundRange.location != NSNotFound {
                        
                    attstr!.addAttribute(NSAttributedString.Key.link, value: url, range: foundRange)
                    }
                    print(url)
                }
                self.contentLabel.attributedText = attstr
                if Auth.auth.language == "ar"{
                    self.contentLabel.textAlignment = .right
                }
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
        }
    }

}
