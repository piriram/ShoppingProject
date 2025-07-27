//
//  ResultViewController.swift
//  ShoppingProject
//
//  Created by piri kim on 7/26/25.
//
// MARK: 검색 결과 리스트 화면
// TODO: 아이패드도 대응해보기
import UIKit
import SnapKit
import Toast

class ResultViewController: UIViewController {
    
    var keyword: String = ""
    private var products: [Product] = []
    private let totalLabel = UILabel()
    private let sortView = SortButtonView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        let width = (UIScreen.main.bounds.width - spacing * 4) / 2
        let height = width * 1.6
        print("width: \(width), height: \(height)")
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = spacing * 2
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
        
        sortView.onSortSelected = { [weak self] sortType in
            self?.fetchProducts()
        }
    }
    
    private func configureUI() {
        view.addSubview(totalLabel)
        totalLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        totalLabel.textColor = .green
        view.addSubview(collectionView)
        
        view.addSubview(sortView)
        sortView.snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(sortView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func fetchProducts() {
        NaverShoppingAPI.shared.fetchProducts(query: keyword, display: 100, sort:sortView.selectedType.rawValue) { [weak self] result in
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
