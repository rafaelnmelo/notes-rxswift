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
    ///Iniciando behavior subject com seu valor inicial
    var users = BehaviorSubject(value: [SectionModel(model: "", items: [User]())])
    
    func fetchUsers() {
        let url = URL(string: "https://demo5399122.mockable.io/notes")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data else{return}
            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
                let sectionUser = SectionModel(model: "First", items: [User(userID: 0, id: 1, title: "Notas", body: "Minhas notas")])
                let secondSection = SectionModel(model: "Second", items: responseData)
                ///Emitindo evento com novo valor
                self.users.on(.next([sectionUser,secondSection]))
            } catch  {
                ///Emitindo evento de erro
                self.users.onError(error)
            }
        }
        task.resume()
    }
    
    func addUser(user: User) {
        guard var sections = try? users.value() else {return}
        var currentSection = sections[0]
        currentSection.items.append(User(userID: 5, id: 25, title: "Nova nota", body: "Esta é sua nota nota"))
        sections[0] = currentSection
        self.users.onNext(sections)///Emitindo evento com novo valor adicionado
    }
    
    func deleteUser(indexPath: IndexPath) {
        guard var sections = try? users.value() else {return}
        var currentSection = sections[indexPath.section]
        currentSection.items.remove(at: indexPath.row)
        sections[indexPath.section] = currentSection
        self.users.onNext(sections)///Emitindo evento com valor removido
    }
    
    func editUser(title: String, indexPath: IndexPath) {
        guard var sections = try? users.value() else {return}
        var currentSection = sections[indexPath.section]
        currentSection.items[indexPath.row].title = title
        sections[indexPath.section] = currentSection
        self.users.onNext(sections)///Emitindo evento editando um valor
    }
}
