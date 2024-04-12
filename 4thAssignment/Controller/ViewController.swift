//
//  ViewController.swift
//  4thAssignment
//
//  Created by Kinam on 4/11/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    // currentProduct가 set되면, imageView. titleLabel, descriptionLabel, priceLabel에 각각 적절한 값을 지정합니다.
    private var currentProduct: RemoteProduct? = nil {
        didSet {
            guard let currentProduct = self.currentProduct else { return }
            
            DispatchQueue.main.async {
                self.setView()
            }
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: currentProduct.thumbnail), let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.imageView.image = image }
                }
            }
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // 위시 리스트 담기 버튼 클릭 시 호출되는 IBAction
    @IBAction func tappedSaveProductButton(_ sender: UIButton) {
        self.saveWishProduct() // Core Data에 상품을 저장하는 함수 호출
    }
    
    // 다른 상품 보기 버튼 클릭 시 호출되는 IBAction
    @IBAction func tappedSkipButton(_ sender: UIButton) {
        self.fetchRemoteProduct() // 새로운 상품을 불러오는 함수 호출
    }
    
    // 위시 리스트 보기 버튼 클릭 시 호출되는 IBAction
    @IBAction func tappedPresentWishList(_ sender: UIButton) {
        // WishListViewController를 가져옵니다.
        guard let nextVC = self.storyboard?
            .instantiateViewController(
                identifier: WishListViewController.identifier
            ) as? WishListViewController else { return }
        
        // WishListViewController를 present 합니다.
        self.present(nextVC, animated: true)
    }
    
    // URLSession을 통해 RemoteProduct를 가져와 currentProduct 변수에 저장합니다.
    private func fetchRemoteProduct() {
        // 1 ~ 100 사이의 랜덤한 Int 숫자를 가져옵니다.
        let productID = Int.random(in: 1 ... 100)
        
        // URLSession을 통해 RemoteProduct를 가져옵니다.
        if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        // product를 디코드하여, currentProduct 변수에 담습니다.
                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        self.currentProduct = product
                        DispatchQueue.main.async {
                            self.refreshControl.endRefreshing()
                        }
                    } catch {
                        print("Decode Error: \(error)")
                    }
                }
            }
            
            // 네트워크 요청 시작
            task.resume()
        }
    }

    // currentProduct를 가져와 Core Data에 저장합니다.
    private func saveWishProduct() {
        guard let context = self.persistentContainer?.viewContext else { return }

        guard let currentProduct = self.currentProduct else { return }

        let wishProduct = Product(context: context)
        
        wishProduct.id = Int64(currentProduct.id)
        wishProduct.title = currentProduct.title
        wishProduct.price = currentProduct.price

        try? context.save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRemoteProduct()
    }
    
    private func setView() {
        imageView.image = nil
        titleLabel.text = currentProduct?.title
        descriptionLabel.text = currentProduct?.description
        priceLabel.text = "\(currentProduct!.price)$"
    }
}

