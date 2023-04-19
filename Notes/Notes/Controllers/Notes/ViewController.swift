//
//  ViewController.swift
//  Notes
//
//  Created by Rafael Melo on 19/04/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {

    private var viewModel = ViewModel()
    private var bag = DisposeBag()
    weak var coordinator: AppCoordinator?
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: self.view.frame, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchUsers()
        bindTableView()
    }
    
    func setupUI() {
        self.title = "Notes"
        self.navigationItem.hidesBackButton = true
        let add = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onTapAdd))
        self.navigationItem.rightBarButtonItem = add
        self.view.addSubview(tableView)
    }
    
    @objc func onTapAdd() {
        let user = User(userID: 25, id: 2505, title: "Lembrete", body: "Minha nota")
        viewModel.addUser(user: user)
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,User>> { _,tableView,indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.id)"
            return cell
        } titleForHeaderInSection: { dataSource, sectionIndex in
            dataSource[sectionIndex].model
        }
        
        self.viewModel.users.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else {return}
            self.viewModel.deleteUser(indexPath: indexPath)
        }).disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Nota", message: "Editar nota", preferredStyle: .alert)
            alert.addTextField { textField in}

            let edit = UIAlertAction(title: "Editar", style: .default) { action in
                let textField = alert.textFields![0] as UITextField
                self.viewModel.editUser(title: textField.text ?? "", indexPath: indexPath)
            }
            
            let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            alert.addAction(edit)

            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: bag)
    }


}

