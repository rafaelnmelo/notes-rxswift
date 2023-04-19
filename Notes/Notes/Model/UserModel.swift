//
//  UserModel.swift
//  Notes
//
//  Created by Rafael Melo on 19/04/23.
//

import Foundation

struct User: Codable {
    let userID, id: Int
    var title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id,title, body
    }
}
