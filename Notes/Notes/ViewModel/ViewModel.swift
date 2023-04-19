//
//  ViewModel.swift
//  Notes
//
//  Created by Rafael Melo on 19/04/23.
//

import Foundation
import RxCocoa
import RxSwift

class ViewModel {
    var users = BehaviorSubject(value: [User]())
    
    func fetchUsers() {
        let url = URL(string: "https://demo5399122.mockable.io/notes")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data else{return}
            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
                self.users.on(.next(responseData))
            } catch  {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
}
