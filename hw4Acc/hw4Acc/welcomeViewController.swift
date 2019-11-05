//
//  welcomeViewController.swift
//  hw2Verify
//  Created by viviana rosas romero on 10/11/19.
// student id: 913305326
//  Copyright © 2019 viv. All rights reserved.
//

import UIKit

class welcomeViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource{

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var listOfAccounts: UITableView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var phoneNumber = ""
    var count = 0
    var walletObj: Wallet?
    let res: [String : Any]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self,action: #selector((closeKeyboard))))
        print("before api user")
    } // end viewDidLoad
    
    func setData(){
        Api.user { response, error in
                guard let response = response else {
                    print("Failed to get user info from API")
                    return
                }
            self.walletObj = Wallet.init(data: response , ifGenerateAccounts: true)
            self.displayData()

        } // end API.user call
    }
    
    func displayData(){
        self.count = walletObj?.accounts.count ?? 0
        self.phoneNumber = walletObj?.phoneNumber ?? "0"
        self.textField.text = walletObj?.userName != "" ? walletObj?.userName : walletObj?.phoneNumber
        self.textField.delegate = self
        self.totalAmount.text = "Balance: \(walletObj?.totalAmount ?? 0.0)"
        self.listOfAccounts.reloadData()
        self.listOfAccounts.dataSource = self
        
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        // pop views and perform segue to login
        self.navigationController?.popToRootViewController(animated: false)
        performSegue(withIdentifier: "logout", sender: nil)
    }
    
    @objc func closeKeyboard(){
        // user clicked outside of edit box, resign first responder and check the string is not empty
        textField.resignFirstResponder()
        if(textField.text == ""){
            textField.text = "\(phoneNumber)" }
 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    } // end tableView function
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        //self.performSegueWithIdentifier("yourIdentifier", sender: self)
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // initialize cell and display name and amount in each respective row
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default , reuseIdentifier: "cell")
        cell.textLabel?.text = " \(walletObj?.accounts[indexPath.row].name ?? "none") : $ \(walletObj?.accounts[indexPath.row].amount ?? 0.0)"
            return cell
    } // end tableView function
    
    @IBAction func editDisplayName(_ sender: Any) {
        textField.isEnabled = true
        textField.allowsEditingTextAttributes = true
    } //editDisplayName
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text, let swiftRange = Range(range, in: currentText) else {
            print("Error with text entered")
            return true
        }
        let nextText = currentText.replacingCharacters(in: swiftRange, with: string)
        textField.text = nextText
         Api.setName(name: nextText) { response, error in
                 if error != nil {
                    print("Succesfully set new userName")
                 } else{
                    print("Error setting username. Try again.")
                }
            } // API.setName
        
        return false
    } // textField
    
} // end class
