//
//  ViewController.swift
//  4thAssignment
//
//  Created by Kinam on 4/11/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var productService = ProductService()

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
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Method --------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRemoteProduct()
        self.setScrollView()
        
    }
    
    // 위시 리스트 담기 버튼 클릭 시 호출되는 IBAction
    @IBAction func tappedSaveProductButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "위시 리스트 담기", message: "위시 리스트에 담겼습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        self.present(alert, animated: true, completion: nil)
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
            productService.fetchRemoteProduct { result in
                switch result {
                case .success(let product):
                    DispatchQueue.main.async {
                        self.currentProduct = product
                        self.refreshControl.endRefreshing()
                    }
                case .failure(let error):
                    print("Error fetching remote product: \(error)")
                }
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
    
    private func setView() {
        imageView.image = nil
        titleLabel.text = currentProduct?.title
        descriptionLabel.text = currentProduct?.description
        priceLabel.text = "\(currentProduct!.price)$"
    }
    
    private func setScrollView() {
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    // CoreData에서 데이터 다시 불러오기
    @objc private func refreshData(_ sender: Any) {
        fetchRemoteProduct()
        
        DispatchQueue.main.async {
            self.scrollView.reloadInputViews()
            self.refreshControl.endRefreshing()
        }
    }
}

