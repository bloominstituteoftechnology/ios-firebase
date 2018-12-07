//
//  Person.swift
//  Firebase Project
//
//  Created by Ivan Caldwell on 12/7/18.
//  Copyright © 2018 Ivan Caldwell. All rights reserved.
//

import Foundation

class Person: Codable, FirebaseItem {
    var name: String
    var cohort: String
    var recordIdentifier = ""
    
    init(name: String, cohort: String) {
        (self.name, self.cohort) = (name, cohort)
    }
}

