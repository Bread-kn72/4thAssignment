//
//  WishListViewController.swift
//  4thAssignment
//
//  Created by Kinam on 4/11/24.
//

import UIKit
import CoreData

class WishListViewController: UIViewController, UITableViewDataSource {

    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    private var productList: [Product] = []
    
    static let identifier = "WishListViewController"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setProductList()
    }

    // CoreData에서 상품 정보를 불러와, productList 변수에 저장합니다.
    private func setProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
    
        let request = Product.fetchRequest()
    
        if let productList = try? context.fetch(request) {
            self.productList = productList
        }
    }
    
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
            productList.remove(at: indexPath.row)
            tableView.deselectRow(at: [indexPath.row], animated: true)
            tableView.reloadData()
        } else if editingStyle == .insert {
            
        }
    }
}
