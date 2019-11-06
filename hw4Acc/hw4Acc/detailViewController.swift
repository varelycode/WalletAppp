//
//  detailViewController.swift
//  hw4Acc
//
//  Created by viv on 11/5/19.
//  Copyright © 2019 viv. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {

    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountBalance: UILabel!
   
    @IBOutlet weak var deleteButton: UIButton!
    
    static var indexPa: Int = 0
    static var deleteAcc = false
    
    var walletObj: Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the data after loading view
        accountName.text = welcomeViewController.wallet?.accounts[detailViewController.indexPa].name
        accountBalance.text = "\(welcomeViewController.wallet?.accounts[detailViewController.indexPa].amount ?? 0.0)"
    }
    
    override func viewDidAppear(_: Bool){
        // set new updates data after returning from popover
        super.viewDidAppear(true)
        accountBalance.text = "\(welcomeViewController.wallet?.accounts[detailViewController.indexPa].amount ?? 0.0)"
    }

    @IBAction func deposit(_ sender: Any) {
        // create an alert and an alert text field to get user input for the deposit amount
        let alert = UIAlertController(title: "Deposit Amount", message: nil, preferredStyle: .alert)
        alert.addTextField{ amountTF in
                        amountTF.placeholder = "Enter amount"
                        amountTF.keyboardType = UIKeyboardType.numberPad
        }// set textfield alert
        let action = UIAlertAction(title: "Add", style: .default){(_) in guard let accNam = alert.textFields?.first?.text else {return}
            let stringToDouble = Double(accNam)
            Api.deposit(wallet: welcomeViewController.wallet!, toAccountAt: detailViewController.indexPa, amount: stringToDouble!){
                            response, error in
                            guard response != nil else { print("Failed to get user info from API")
                                                    return }// end guard
                if(error == nil){
                    print("succesfull removed account")
                    self.accountBalance.text = "\(welcomeViewController.wallet?.accounts[detailViewController.indexPa].amount ?? 0.0)"
                }//end if
            } // end api deposit
        } // end let action
        // add cancel button for alert and present alert
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in
                  print("cancel withdrawl")
              }))
        alert.addAction(action)
        present(alert,animated:true)
    } // end deposit function
    
    @IBAction func withdraw(_ sender: Any) {
        let alert = UIAlertController(title: "Withdraw Amount", message: nil, preferredStyle: .alert)
        alert.addTextField{ amountTF in
                            amountTF.placeholder = "Enter amount"
                             amountTF.keyboardType = UIKeyboardType.numberPad
        } // end alert text
                          
        let action = UIAlertAction(title: "Withdraw", style: .default){(_) in guard let accNam = alert.textFields?.first?.text else {return}
                var stringToDouble = Double(accNam)
                // convert text to double and check that it is bigger than user balance
            if (Int(stringToDouble ?? 0.0 ) > Int(welcomeViewController.wallet?.accounts[detailViewController.indexPa].amount ?? 0.0)){
                                       stringToDouble = welcomeViewController.wallet?.accounts[detailViewController.indexPa].amount ?? 0.0
                                    }
        Api.withdraw(wallet: welcomeViewController.wallet!, fromAccountAt: detailViewController.indexPa, amount: (stringToDouble ?? 0.0)){
                     response, error in
                         guard response != nil else {
                         print("Failed to get user info from API")
                         return
                     }// end guard

                         if(error == nil){

                             print("succesfull  withdrawn amount")
                             self.accountBalance.text = "\(welcomeViewController.wallet?.accounts[detailViewController.indexPa].amount ?? 0.0)"
                            
                            } // end error if
                 }// end API withdraw
        } // action
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in
            print("cancel withdrawl")
        }))
        alert.addAction(action)
        present(alert,animated:true)
    } // end func
    
    
    @IBAction func transfer(_ sender: Any) {
        //prepare for custom popover when to transfer from two accounts
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "popupViewController") as! popupViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func doneAndSave(_ sender: Any) {
        //dismiss once the user presses done
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        detailViewController.deleteAcc = true
        //withdraw the money from target account to remove from total balance
        Api.withdraw(wallet: welcomeViewController.wallet ?? Wallet(), fromAccountAt: detailViewController.indexPa, amount: (welcomeViewController.wallet?.accounts[detailViewController.indexPa].amount)!){
              response, error in
                  guard response != nil else {
                  print("Failed to get user info from API")
                  return
            }// end guard
            if(error == nil){ print("succesfull removed account")} // end error if
        }// end API withdraw
        // remove the account
        Api.removeAccount(wallet: welcomeViewController.wallet ?? Wallet(), removeAccountat: detailViewController.indexPa){ response, error in
                 guard response != nil else {
                 print("Failed to get user info from API")
                 return }// end guard
            if(error == nil){ print("succesfull removed account") }
        }// end API
        self.dismiss(animated: true)
    } // end func
} // ENDOFCLASS
