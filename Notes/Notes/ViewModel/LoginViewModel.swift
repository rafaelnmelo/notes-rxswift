//
//  LoginViewModel.swift
//  Notes
//
//  Created by Rafael Melo on 19/04/23.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {
    var email: BehaviorSubject<String> = BehaviorSubject(value: "")
    var password: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var isValidEmail: Observable<Bool> {
        email.map { $0.isValidEmail }
    }
    
    var isValidPassword: Observable<Bool> {
        password.map { $0.count >= 6 }
    }
    var isValidInput: Observable<Bool> {
        return Observable.combineLatest(isValidEmail,isValidPassword).map({$0 && $1})
    }
}
