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
    ///Variavel observável calculada de acordo com o valor email do objeto
    var isValidEmail: Observable<Bool> {
        email.map { $0.isValidEmail }
    }
    ///Igual o anterior com o valor senha do objeto
    var isValidPassword: Observable<Bool> {
        password.map { $0.count >= 6 }
    }
    ///Variavel observável calculada combinando o valor de outras duas
    var isValidInput: Observable<Bool> {
        return Observable.combineLatest(isValidEmail,isValidPassword).map({$0 && $1})
    }
}
