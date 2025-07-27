//
//  ResultViewController.swift
//  ShoppingProject
//
//  Created by piri kim on 7/26/25.
//
// MARK: 검색 결과 리스트 화면
import UIKit
import SnapKit
import Toast

class ResultViewController: UIViewController {
    
    var keyword: String = ""
    private var products: [Product] = []
    private let totalLabel = UILabel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 4
        let width = (UIScreen.main.bounds.width - spacing * 3) / 2
        layout.itemSize = CGSize(width: width, height: 300)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToast()
        title = keyword
        
        configureUI()
        fetchProducts()
    }
    
    private func configureUI() {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func fetchProducts() {
        NaverShoppingAPI.shared.fetchProducts(query: keyword, display: 100) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.products = response.items
                    self?.totalLabel.text = "\(response.total.decimalString) 개의 검색 결과"
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.view.makeToast("상품을 불러오는 데 실패했습니다", duration: 2.0, position: .center)
                    print(error)
                }
            }
        }
    }
    func configureToast() {
        var style = ToastStyle()
        style.backgroundColor = .white
        style.messageColor = .black
        ToastManager.shared.style = style
    }
}

extension ResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureData(products[indexPath.item])
        return cell
    }
}
