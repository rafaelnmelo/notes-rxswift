//
//  ViewController+TableView.swift
//  Notes
//
//  Created by Rafael Melo on 19/04/23.
//

import UIKit

extension ViewController {
    

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}
