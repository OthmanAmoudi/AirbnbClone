//
//  User.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import Foundation
//struct User {
//    var username:String
//    var email:String
//    var profilePictureURL:String
//}


internal class User {
    internal let id: String
    internal let name: String
    internal let email: String
    internal let proPicURL: String
    
    init(id: String, name: String, email:String, proPicURL:String) {
        self.id = id
        self.name = name
        self.email = email
        self.proPicURL = proPicURL
    }
}
