//
//  walletClass.swift
//  hw3Typing
//
//  Created by viv on 10/29/19.
//  Copyright © 2019 viv. All rights reserved.
//

import Foundation



class wallet{ // class created to share variables between view controllers
    
    
    var name: String? // used to store phone number of an instance
    
    
    var userName: String = ""
    var phoneNumber: String = ""
    var walletCount: Int = 0
    var balance: Double = 0
    
    var myResponse: [String : Any]? = nil
    
    var accounts: [Any]? = nil
    
    var wallet: Any? = nil
    var names: [Any]? = nil
    var amount: [Any]? = nil
    var ID: [Any]? = nil
    
        
    
    func setResponse(res: [String: Any]?){
        
        
        myResponse = res
        
        //wallet = Wallet.init(data: myResponse! , ifGenerateAccounts: true)

        
        
    }
    
    
    func printWallet() {
        print("***********")
        print("totle amount:\(self.balance)")
        print("List of Accounts:")
        for i in 0...4 {
            print("  \(names?[i] ?? "none") has \(amount?[i] ?? "none")")
        }
    }

    
    
   
    
    
    
    
    
    
}
