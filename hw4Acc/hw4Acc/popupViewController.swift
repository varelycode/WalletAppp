//
//  popupViewController.swift
//  hw4Acc
//
//  Created by viv on 11/5/19.
//  Copyright © 2019 viv. All rights reserved.
//

import UIKit

class popupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
    @IBOutlet weak var transferAmount: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    static var dollarAmount : Double = 0.0
    
    static var indexSelected : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelSelection(_ sender: Any) {
        // if user cancels , dismiss popover
        self.dismiss(animated:true)
        
    }
    
    @IBAction func saveSelected(_ sender: Any) {
        // save selected input
        var input = ""
        input.append(transferAmount.text ?? "")
        popupViewController.dollarAmount = Double(input) ?? 0.0 // convert to double
        withdraw()
        
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        } // end dispatch
    } // end save selected
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { // how many picker columns we want
        return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { // return the amount of accounts
        guard let count = welcomeViewController.wallet?.accounts.count else{
                   return 0
               }
        return count
     }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //select a row
        popupViewController.indexSelected = row
    }
    
    func withdraw(){
        
        var stringToDouble = popupViewController.dollarAmount
        // convert text to double and check that it is bigger than user balance
        if (Int(stringToDouble ) > Int(welcomeViewController.wallet?.accounts[detailViewController.indexPa].amount ?? 0.0)){
                        stringToDouble = welcomeViewController.wallet?.accounts[detailViewController.indexPa].amount ?? 0.0
                     }
        Api.withdraw(wallet: welcomeViewController.wallet ?? Wallet(), fromAccountAt: detailViewController.indexPa, amount: stringToDouble ){
                        response, error in
                            guard response != nil else {
                            print("Failed to get user info from API")
                            return
                        }// end guard

            if(error == nil){ print("succesfull  withdrawn amount") } // end error if
            self.deposit(amountTo: stringToDouble)
        }// end API withdraw
    }
    
    func deposit(amountTo: Double){
        
        Api.deposit(wallet: welcomeViewController.wallet ?? Wallet(), toAccountAt: popupViewController.indexSelected, amount: amountTo){
                            response, error in guard response != nil else { print("Failed to get user info from API")
                                                    return }// end guard

            if(error == nil){ print("succesfull removed account") } // end error if
        } // end api deposit
    } // end func
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // set the pickerView title
        let title = "\(welcomeViewController.wallet?.accounts[row].name ?? "Error "): \(welcomeViewController.wallet?.accounts[row].amount ?? 0.0)"
        return title
    } // end func
} //ENDOFCLASS
