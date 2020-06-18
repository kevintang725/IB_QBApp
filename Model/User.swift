//
//  User.swift
//  IB_QuestionBank_V0
//
//  Created by Kevin Tang on 18/6/2020.
//  Copyright © 2020 Kevin Tang. All rights reserved.
//

import UIKit
import Firebase

class User: NSObject {
    // Initialize Firebase References
    let ref = Database.database().reference()
    let storage = Storage.storage()
    
    let userID: String
    
    override init() {
        userID = self.ref.child("users").child(Auth.auth().currentUser!.uid).child("name")
    }
}
