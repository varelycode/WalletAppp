//
//  verifyViewController.swift
//  hw2Verify
//
//  Created by viviana rosas romero on 10/11/19.
// student id: 913305326
//  Copyright © 2019 viv. All rights reserved.
//

import UIKit

class verifyViewController: UIViewController, PinTexFieldDelegate {

    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    let storageInstance = Storage.init()
 
    
    @IBOutlet var codeInput: [PinTextField]!
    
    var endEdit = false
    var reachedEnd = false
    var codeArray = ""
    var codeIterator = 0
    var valuedEntered = false
    var backspaceEntered = false
    
    @IBOutlet weak var responseCodeLabel: UILabel!
    
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        self.codeInput[0].delegate = self
        self.codeInput[1].delegate = self
        self.codeInput[2].delegate = self
        self.codeInput[3].delegate = self
        self.codeInput[4].delegate = self
        self.codeInput[5].delegate = self
        self.codeInput[0].becomeFirstResponder()
         // Do any additional setup after loading the view.
     }
    

    func didPressBackspace( textField : PinTextField){
    
        
        codeInput[codeIterator].isEnabled = false
        codeInput[codeIterator].resignFirstResponder()
        codeInput[codeIterator].allowsEditingTextAttributes = false
         
        if(codeIterator != 0){
            codeArray.removeLast(1)
            codeInput[codeIterator - 1].isEnabled = true
            codeInput[codeIterator - 1].becomeFirstResponder()
            codeInput[codeIterator - 1].allowsEditingTextAttributes = true
            codeIterator -= 1
          
        }
        
        if(codeIterator == 0){
            codeArray = ""
            codeInput[codeIterator].isEnabled = true
            codeInput[codeIterator].becomeFirstResponder()
            codeInput[codeIterator].allowsEditingTextAttributes = true
            
            
        }
        
        
        
    }
        

    
    
    
    
    @IBAction func resendCode(_ sender: UIButton) {
        

        let codeResent = resendCode()
        
        if(codeResent == true){ // checks if the code was sent
            self.responseCodeLabel.text = "Code was resent. "
        }else{
            self.responseCodeLabel.text = "Error resending code. "
        }
        
        
    } // resend code function
    @IBAction func singleEdit(_ sender: UITextField) {
        
        
        print("singleEdit")
        

        
        var codeVerified = false // track if we verify code correctly
        reachedEnd = false // track when the user input has reached to the end
        
        
        if codeInput[codeIterator].text?.count == 1{
            
            codeArray.append(codeInput[codeIterator].text ?? "")
                print(codeArray) // append input to codeArray
            
            if codeInput[5].isFirstResponder{ // check if we reached end and reset input
                
                codeInput[5].resignFirstResponder()
                // display activity indicator before calling API
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.style = UIActivityIndicatorView.Style.medium
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                codeVerified = verifyCode()
                reachedEnd = true
                
                if !codeVerified{
                
                    for i in 0...5{ // reset text input for reentry
                        codeInput[i].text = nil
                        codeInput[i].isEnabled = false
                        codeInput[i].allowsEditingTextAttributes = false
                    }
                    
                    codeArray = ""
                    codeInput[5].allowsEditingTextAttributes = false
                    codeInput[5].isEnabled = false
                    codeInput[0].isEnabled = true
                    codeInput[0].becomeFirstResponder()
                    codeInput[0].allowsEditingTextAttributes = true
                    codeIterator = 0


                }
                
            } else{ // disable current text box and enable next text box for input
            codeInput[codeIterator].resignFirstResponder()
                //if (codeIterator != 0){
                    codeInput[codeIterator].allowsEditingTextAttributes = false
            
                    codeInput[codeIterator].isEnabled = false
                //}
            codeInput[codeIterator + 1].isEnabled = true
            codeInput[codeIterator + 1].becomeFirstResponder()
            codeInput[codeIterator + 1].allowsEditingTextAttributes = true
            //codeInput[codeIterator + 1].isSelected = true
            }
            if(codeIterator < 5 && reachedEnd == false){
                codeIterator += 1} // iterate for our next input value
            
        } // if number entered
    } // func singleEdit

    
    func resendCode() -> Bool{ // resends verification code
        
        var codeVerified = true
        guard let phoneNumber = phoneViewController.sharedPhone.name else { return false }
        
        Api.sendVerificationCode(phoneNumber: phoneNumber){ response, error in
                           
                      if error?.code == "invalid_phone_number" { // incorrect phone
                          self.activityIndicator.stopAnimating()
                          self.view.isUserInteractionEnabled = true
                          codeVerified = false
                      }
                      
                      if(error == nil){ // success
                         self.activityIndicator.stopAnimating()
                         codeVerified = true
                      }
                       }
        
        return codeVerified
        
    }
    
    
    func verifyCode() -> Bool { // verifies the code

         var codeVerified = false
         let phoneNumber = phoneViewController.sharedPhone.name
        
        
        
        Api.verifyCode(phoneNumber: phoneNumber ?? "error", code: codeArray){ response, error in
            
          
            
            if error?.code == "incorrect_code" {
                self.activityIndicator.stopAnimating()
                self.responseCodeLabel.text = "Incorrect code please try again"
                codeVerified = false
            }
            
            if error?.code == "code_expired"{
                self.activityIndicator.stopAnimating()
                self.responseCodeLabel.text = "Code is expired. Resend code."
                
                codeVerified = false
            }
            
            if(error == nil){ // correct so perform segue
                guard let phoneNumber = phoneViewController.sharedPhone.name else { return }
                Storage.phoneNumberInE164 = phoneNumber
                if let authToken = response?["auth_token"] as? String {
                    Storage.authToken = authToken
                }
                self.activityIndicator.stopAnimating()
                self.responseCodeLabel.text = "correct. code is verified"
                self.performSegue(withIdentifier: "verifytowelcome", sender: nil)
                //self.present(welcomeViewController(), animated: true, completion: nil)
                codeVerified = true
            }
            }
        return codeVerified
    } // func verifyCode
    
    

} // class verifyViewController

