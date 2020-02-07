//
//  InitialViewController.swift
//  Opto-Screen
//
//  Created by Rus Wang on 1/25/20.
//  Copyright © 2020 New User. All rights reserved.
//

import UIKit
import Purchases

class InitialViewController: UIViewController {
    
    @IBOutlet weak var goPremiumButton: UIButton!
    @IBOutlet weak var restorePurchasesButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var purchaseDateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Get the latest purchaserInfo to see if we have a pro user or not
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            
            // Route the view depending if we have a premium  user or not
            if purchaserInfo?.entitlements["Opto-Screen Full"]?.isActive == true {
                
                
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "NavigationController")
//                controller.modalPresentationStyle = .fullScreen
//                self.present(controller, animated: true, completion: nil)
                
                print("CONGRATULATIONS ON YOUR PURCHASE OF THE OPTO-SCREEN IOS PUPIL APP!")
                
                // adaptive color for dark mode
//                self.contentLabel.text = "Welcome user! For information regarding how to use the app, please visit https://visualintelligence.us/written-instructions/ For general info, please visit https://visualintelligence.us"
                if #available(iOS 13.0, *) {
                    self.purchaseDateLabel.textColor = UIColor.label
                    self.expirationDateLabel.textColor = UIColor.label
                } else {
                    self.purchaseDateLabel.textColor = UIColor.systemGray
                    self.expirationDateLabel.textColor = UIColor.systemGray
                }

                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                
                if let purchaseDate = purchaserInfo?.purchaseDate(forEntitlement: "Opto-Screen Full") {
                    self.purchaseDateLabel.text = "Purchase Date: \(dateFormatter.string(from: purchaseDate))"
                }
                if let expirationDate = purchaserInfo?.expirationDate(forEntitlement: "Opto-Screen Full") {
                    self.expirationDateLabel.text = "Expiration Date: \(dateFormatter.string(from: expirationDate))"
                }
                
            } else {
                
                // if we don't have a pro subscriber, send them to the upsell screen
                let controller = SwiftPaywall(
                    termsOfServiceUrlString: "https://visualintelligence.us/terms-of-service/",
                    privacyPolicyUrlString: "https://visualintelligence.us/privacy-policy/")

                controller.titleLabel.text = "Welcome to Opto-Screen"
                controller.subtitleLabel.text = "We provide optical diagnostic information and artificial intelligence for physicians and more!"
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func closeButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NavigationController")
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}
