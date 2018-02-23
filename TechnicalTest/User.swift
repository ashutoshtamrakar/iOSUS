//
//  User.swift
//  TechnicalTest
//
//  Created by AT on 22/02/18.
//  Copyright © 2018 UbiqueSystems. All rights reserved.
//

import Foundation

struct User {
    
    public var emailID: String?
    public var password: String?
    
    init(emailID: String?, password: String?) {
        self.emailID = emailID
        self.password = password
    }
}
