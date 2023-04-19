//
//  ViewController.swift
//  Notes
//
//  Created by Rafael Melo on 19/04/23.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    private var viewModel = ViewModel()
    private var bag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: self.view.frame, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notes"
        let add = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onTapAdd))
        self.navigationItem.rightBarButtonItem = add
        self.view.addSubview(tableView)
        viewModel.fetchUsers()
        bindTableView()
    }
    
    @objc func onTapAdd() {
        let user = User(userID: 25, id: 2505, title: "Rafan", body: "um arraso")
        viewModel.addUser(user: user)
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)
        viewModel.users.bind(to: tableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) { (row,item,cell) in
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.id)"
        }.disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Note", message: "Edit note", preferredStyle: .alert)
            alert.addTextField { textField in}
            
            let action = UIAlertAction(title: "Edit", style: .default) { action in
                let textField = alert.textFields![0] as UITextField
                self.viewModel.editUser(title: textField.text ?? "", index: indexPath.row)
            }
            alert.addAction(action)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {return}
            self.viewModel.deleteUser(index: indexPath.row)
        }).disposed(by: bag)

    }


}

