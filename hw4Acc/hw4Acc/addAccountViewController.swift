//
//  addAccountViewController.swift
//  hw4Acc
//
//  Created by viv on 11/5/19.
//  Copyright © 2019 viv. All rights reserved.
//

import UIKit

class addAccountViewController: UIViewController {

    @IBOutlet weak var accountName: UITextField!
    static var newAccountName: String = ""
    override func viewDidLoad() {
                super.viewDidLoad()
    }
    
    @IBAction func cancelButton(_ sender: Any) { // if the user, presses cancel
        self.dismiss(animated: true)
    }
    
    @IBAction func saveName(_ sender: Any) {
        // once the user has finished entering the new name, save the name and add the new account to the API
        addAccountViewController.newAccountName = accountName.text ?? "Account \((welcomeViewController.wallet?.accounts.count ?? 0))"
        //Check if our account name is empty, if it is, assign the name
        if(addAccountViewController.newAccountName == ""){
            addAccountViewController.newAccountName = "Account \((welcomeViewController.wallet?.accounts.count ?? 0))"
        }
        Api.addNewAccount(wallet: welcomeViewController.wallet ?? Wallet(), newAccountName: addAccountViewController.newAccountName ){ response, error in guard response != nil else { print("Failed to get user info from API")
                                         return }// end guard
            if(error == nil){ print("succesfull added account") }
        }// add new account
        DispatchQueue.main.async { self.dismiss(animated: true) } // end dispatch
    }// end func saveName
} // ENDOFCLASS

