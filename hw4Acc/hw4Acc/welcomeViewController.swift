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
    static var wallet: Wallet?
    let res: [String : Any]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        // removed gesture recognizer because it was causing issues with table
        /*  self.view.addGestureRecognizer(UITapGestureRecognizer(target:self,action: #selector((closeKeyboard))))
            print("before api user")
        */
    } //end viewDidLoad
    
    
    override func viewDidAppear(_: Bool){ // after returning from popover view controller, go here
        super.viewDidAppear(true)
        self.displayData()
        
    }

    @IBAction func addNewAccount(_ sender: Any) {
        // present add new account view
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewController(identifier: "addAccountViewController") as! addAccountViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

}
    // refactored code from view did load into methods to fix a bug pertaining to new users
    func setData(){ // init our wallet object with API user
        Api.user { response, error in
                guard let response = response else {
                    print("Failed to get user info from API")
                    return
                } // end guard statement
            self.walletObj = Wallet.init(data: response , ifGenerateAccounts: true)
            welcomeViewController.wallet = self.walletObj
            self.displayData()

        } // end API.user call
    }
    
    func displayData(){ // update UI data NOTE: refactored from viewdid load to fix new user bug
        self.count = walletObj?.accounts.count ?? 0
        self.phoneNumber = walletObj?.phoneNumber ?? "0"
        self.textField.text = walletObj?.userName != "" ? walletObj?.userName : walletObj?.phoneNumber
        self.textField.delegate = self
        if (walletObj?.accounts.count == 0){ // make sure balance is zero when you have no accounts

            self.totalAmount.text = "Balance: 0.0"

        }else{
            self.totalAmount.text = "Balance: \(walletObj?.totalAmount ?? 0.0)"
        }
        self.listOfAccounts.delegate = self
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
        // set indexpath.row to our index to access the selection later
        detailViewController.indexPa = indexPath.row
        //present the detail view when user selects a row
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "detailViewController") as! detailViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // initialize cell and display name and amount in each respective row
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default , reuseIdentifier: "cell")
        cell.textLabel?.text = " \(walletObj?.accounts[indexPath.row].name ?? "none") : $ \(walletObj?.accounts[indexPath.row].amount ?? 0.0)"
            return cell
    } // end tableView function
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // implemented an alternative delete functionality for the table rows. User can still delete an item in the detail view
        if(editingStyle == UITableViewCell.EditingStyle.delete){
            removeThis(indexPath: indexPath.row)
            DispatchQueue.main.async {
                self.displayData()
            } // end DispatchQueue
        }// end if
    } // end func
    
    func removeThis(indexPath: Int){ // function is called when the user performs a left delete swipe
        
        guard let wal = walletObj else{
            return
        }
        Api.removeAccount(wallet: wal, removeAccountat: indexPath){ response, error in
                           guard response != nil else {
                           print("Failed to get user info from API")
                           return
                       }// end guard
                           if(error == nil){
                               print("succesfull removed account")
                           } // end if
                       }// end Api
    } // end func removeThis
    
    @IBAction func editDisplayName(_ sender: Any) {
        textField.isEnabled = true
        textField.allowsEditingTextAttributes = true
    } // end func
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text, let swiftRange = Range(range, in: currentText) else {
            print("Error with text entered")
            return true
        } // end guard
        let nextText = currentText.replacingCharacters(in: swiftRange, with: string)
        textField.text = nextText
         Api.setName(name: nextText) { response, error in
                 if error != nil {
                    print("Succesfully set new userName")
                 } else{
                    print("Error setting username. Try again.")
                } // end else
            } // API.setName
        
        return false
    } // end func
} //ENDCLASS
