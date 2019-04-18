//
//  CurrentUser.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 18/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import Foundation

struct CurrentUser {
    let uid: String
    let name: String
    let email: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
