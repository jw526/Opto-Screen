//
//  CatsViewController.swift
//  Opto-Screen
//
//  Created by Rus Wang on 1/25/20.
//  Copyright © 2020 New User. All rights reserved.
//


// boiler plate. Not used 
import UIKit
import Purchases

class InfoController: UIViewController {
    
    @IBOutlet weak var goPremiumButton: UIButton!
    @IBOutlet weak var restorePurchasesButton: UIButton!
    @IBOutlet weak var catContentLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var purchaseDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goPremiumButton.addTarget(self, action: #selector(goPremiumButtonTapped), for: .touchUpInside)
        restorePurchasesButton.addTarget(self, action: #selector(restorePurchasesButtonTapped), for: .touchUpInside)
        
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            self.configureCatContentFor(purchaserInfo: purchaserInfo)
        }

    }
    
    func configureCatContentFor(purchaserInfo: Purchases.PurchaserInfo?) {
        
        // set the content based on the user subscription status
        if let purchaserInfo = purchaserInfo {
            
            if purchaserInfo.entitlements["pro_cat"]?.isActive == true {
                
                print("Hey there premium, you're a happy cat 😻")
                self.catContentLabel.text = "😻"
                self.goPremiumButton.isHidden = true
                self.restorePurchasesButton.isHidden = true
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                
                if let purchaseDate = purchaserInfo.purchaseDate(forEntitlement: "pro_cat") {
                    self.purchaseDateLabel.text = "Purchase Date: \(dateFormatter.string(from: purchaseDate))"
                }
                if let expirationDate = purchaserInfo.expirationDate(forEntitlement: "pro_cat") {
                    self.expirationDateLabel.text = "Expiration Date: \(dateFormatter.string(from: expirationDate))"
                    
                }
                
            } else {
                print("Happy cats are only for premium members 😿")
                self.catContentLabel.text = "😿"
            }
        }
    }
    
    
    @objc func goPremiumButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func restorePurchasesButtonTapped() {
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            if let e = error {
                print("RESTORE ERROR: - \(e.localizedDescription)")
            }
            self.configureCatContentFor(purchaserInfo: purchaserInfo)
                
        }
    }
}
