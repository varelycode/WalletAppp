//
//  phoneViewController.swift
//  hw1login
//
//  Created by Viviana Rosas Romero on 10/10/19.
// 913305326
//  Copyright © 2019 viv. All rights reserved.
//

import UIKit
import PhoneNumberKit






class phoneViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let sharedPhone = phoneNumber()
    
    let phoneNumberKit = PhoneNumberKit()
    //var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    

    @IBOutlet weak var phoneNumberText: PhoneNumberTextField!
    
    @IBOutlet weak var errorIndicator: UILabel!
    
    @IBOutlet weak var errorNotify: UILabel!
    
   override func viewDidLoad() {
        super.viewDidLoad()
    
    activityIndicator.alpha = 0.0
    
        phoneNumberText.delegate = self
    
    phoneNumberText.text = Storage.phoneNumberInE164
    
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self,action: #selector((closeKeyboard))))
   }
    
    @objc func closeKeyboard(){
        phoneNumberText.resignFirstResponder()
    }
    
    var formatNumber = ""
    @IBAction func Next(_ sender: UIButton) {
        
        guard let stringUnwrap = phoneNumberText?.text else { return }
        
        
        do {
            let phoneNumber = try phoneNumberKit.parse(phoneNumberText.text ?? stringUnwrap)

            
            formatNumber = phoneNumberKit.format(phoneNumber, toType: .e164)
            
            
            phoneViewController.sharedPhone.name = formatNumber
            
            if phoneNumber.countryCode != 1{

                errorIndicator.text = "🚫"
                errorNotify.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                errorNotify.text = "Country code is not 1. Enter US number"

            }
            else{
                errorNotify.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                errorNotify.text = "Verification code sent to \(formatNumber) "
                errorIndicator.text = "✅"
                
                
                
                activityIndicator.alpha = 1.0
                activityIndicator.startAnimating()
                view.isUserInteractionEnabled = false
                
                
                if Storage.authToken != nil, Storage.phoneNumberInE164 == self.formatNumber {
                    self.view.isUserInteractionEnabled = true
                    
                    performSegue(withIdentifier: "skipverification", sender: nil)
                    //present(verifyViewController(), animated: true, completion: nil)
                }else{
                    _ = verifyCode()
                }
                
                
                             
                
                
            }
            phoneNumberText.resignFirstResponder()
        }
        catch {
            
            guard let stringUnwrap = phoneNumberText?.text else { return }
            validateNumber(stringUnwrap: stringUnwrap)

        }
    }
    
    func response(){
        
        print("true")
    }
    
    func err(){
        
        print("error")
    }
    
    
    func verifyCode() -> Bool {
        
      
        var codeVerified = false
        guard let phoneNumber = phoneViewController.sharedPhone.name else { return false }
        
        
       Api.sendVerificationCode(phoneNumber: phoneNumber){ response, error in
                         
                         if error?.code == "invalid_phone_number" {
                             self.activityIndicator.alpha = 0.0
                             self.activityIndicator.stopAnimating()
                             self.view.isUserInteractionEnabled = true
                             codeVerified = false
                         }
                         
                         if(error == nil){
                            self.activityIndicator.alpha = 0.0
                            self.activityIndicator.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            self.performSegue(withIdentifier: "sendtoverify", sender: nil)
                            //self.present(verifyViewController(), animated: true, completion: nil)
                                
                            codeVerified = true
                         }
                         
        }
        return codeVerified
    } // func verifyCode
    
    
    func validateNumber(stringUnwrap: String){
            errorIndicator.text = "🚫"
            errorNotify.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            errorNotify.text = "Number is invalid. Enter 10 digit number."
        
    }

}
