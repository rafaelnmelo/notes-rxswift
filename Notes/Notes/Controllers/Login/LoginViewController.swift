//
//  LoginViewController.swift
//  Notes
//
//  Created by Rafael Melo on 19/04/23.
//

import RxSwift
import RxCocoa
import UIKit

class LoginViewController: UIViewController {
    
    var bag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    lazy var textFieldEmail: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Informe seu email"
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .emailAddress
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var textFieldPassword: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Informe sua senha"
        textfield.borderStyle = .roundedRect
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var btnLogin: UIButton = {
        let btn = UIButton()
        btn.setTitle("login", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.black.withAlphaComponent(0.3), for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemRed
        btn.addTarget(self, action: #selector(onTapBtnLogin), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createObservables()
    }
    
    @objc func onTapBtnLogin() {
        
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(textFieldEmail)
        self.view.addSubview(textFieldPassword)
        self.view.addSubview(btnLogin)
        
        NSLayoutConstraint.activate([
            textFieldEmail.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            textFieldEmail.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 20),
            
            textFieldPassword.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor,constant: 20),
            
            btnLogin.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 20),
            btnLogin.widthAnchor.constraint(equalTo: textFieldPassword.widthAnchor),
            btnLogin.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func createObservables() {
        textFieldEmail.rx.text.map({$0 ?? ""}).bind(to: viewModel.email).disposed(by: bag)
        textFieldPassword.rx.text.map({$0 ?? ""}).bind(to: viewModel.password).disposed(by: bag)
        
        viewModel.isValidInput.bind(to: btnLogin.rx.isEnabled).disposed(by: bag)
        viewModel.isValidInput.subscribe(onNext: { [weak self] isValid in
            self?.btnLogin.backgroundColor = isValid ? .systemBlue : .systemRed
        }).disposed(by: bag)
    }
}
