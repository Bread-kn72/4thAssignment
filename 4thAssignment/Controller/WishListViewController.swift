//
//  WishListViewController.swift
//  4thAssignment
//
//  Created by Kinam on 4/11/24.
//

import UIKit

class WishListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    static var identifier = "WishListViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WishListViewController", bundle: nil), forCellReuseIdentifier: WishListViewController.identifier)
    }
}

extension WishListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListViewController.identifier, for: indexPath) as? WishListCell else {
            return UITableViewCell()
        }
        return cell
    }
}
