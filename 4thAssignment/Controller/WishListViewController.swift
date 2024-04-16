//
//  WishListViewController.swift
//  4thAssignment
//
//  Created by Kinam on 4/11/24.
//

import UIKit
import CoreData

class WishListViewController: UIViewController {

    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    private var productList: [Product] = []
    static let identifier = "WishListViewController"
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setTableViewRefreshControl()
    }

    // CoreData에서 상품 정보를 불러와, productList 변수에 저장합니다.
    private func setProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
    
        let request = Product.fetchRequest()
    
        if let productList = try? context.fetch(request) {
            self.productList = productList
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        // CoreData에서 데이터 다시 불러오기
        setProductList()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func setTableViewRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        setProductList()
    }
}

extension WishListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
                let product = self.productList[indexPath.row]
        
                let id = product.id
                let title = product.title ?? ""
                let price = product.price
        
                cell.textLabel?.text = "[\(id)] \(title) - \(price)$"
                return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let context = self.persistentContainer?.viewContext {
                let productToRemove = self.productList[indexPath.row]
                context.delete(productToRemove)
                do {
                    try context.save()
                } catch {
                    print("Failed to save context: \(error)")
                }
            }
            productList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            
        }
    }
}
