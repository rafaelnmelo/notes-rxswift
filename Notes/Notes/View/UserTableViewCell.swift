//
//  UserTableViewCell.swift
//  Notes
//
//  Created by Rafael Melo on 19/04/23.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "UserTableViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
