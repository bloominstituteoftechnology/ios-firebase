//
//  PersonCell.swift
//  Detail
//
//  Created by Madison Waters on 11/14/18.
//  Copyright © 2018 Jonah Bergevin. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
   static let reuseIdentifier = "person cell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cohortLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
}
