//
//  ViewModel.swift
//  Notes
//
//  Created by Rafael Melo on 19/04/23.
//

import Foundation
import RxCocoa
import RxSwift
import Differentiator

class ViewModel {
    var users = BehaviorSubject(value: [SectionModel(model: "", items: [User]())])
    
    func fetchUsers() {
        let url = URL(string: "https://demo5399122.mockable.io/notes")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data else{return}
            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
                let sectionUser = SectionModel(model: "First", items: [User(userID: 0, id: 1, title: "Rafan", body: "Um arraso")])
                let secondSection = SectionModel(model: "Second", items: responseData)
                self.users.on(.next([sectionUser,secondSection]))
            } catch  {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func addUser(user: User) {
        guard var sections = try? users.value() else {return}
        var currentSection = sections[0]
        currentSection.items.append(User(userID: 5, id: 25, title: "New data", body: "This is the new data"))
        sections[0] = currentSection
        self.users.onNext(sections)
    }
    
    func deleteUser(indexPath: IndexPath) {
        guard var sections = try? users.value() else {return}
        var currentSection = sections[indexPath.section]
        currentSection.items.remove(at: indexPath.row)
        sections[indexPath.section] = currentSection
        self.users.onNext(sections)
    }
    
    func editUser(title: String, indexPath: IndexPath) {
        guard var sections = try? users.value() else {return}
        var currentSection = sections[indexPath.section]
        currentSection.items[indexPath.row].title = title
        sections[indexPath.section] = currentSection
        self.users.onNext(sections)
    }
}
