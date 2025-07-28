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
    var display = 30
    var currentStart = 1
    var hasMoreData: Bool = true
    var isLoading = false
    var isReset = false
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
        collectionView.delegate = self
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
            self?.isReset = true
            
            self?.hasMoreData = true
            self?.products = []
            self?.currentStart = 1
            self?.collectionView.setContentOffset(.zero, animated: true)
            self?.collectionView.reloadData()
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
//            $0.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(sortView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func fetchProducts() {
        /// 페이지 네이션 중복 요청 방지
        /// 로딩중이거나 가져올 데이터가 없으면 함수 실행 종료
        guard !isLoading,hasMoreData else { return }
        isLoading = true
        /// 새로 조회할 때
        if isReset {
            
            currentStart = 1
            hasMoreData = true
            products = []
            /// fatal error 원인?
//            collectionView.reloadData()
            
            isReset = false
        }
        NaverShoppingAPI.shared.fetchAllQueryProducts(query: keyword, display: 30, sort: sortView.selectedType.rawValue, start: currentStart ){ [weak self] result in
            
            guard let self = self else { return } /// weak self의 순환 참조를 방지하기 위해 옵셔널 체이닝 되던것에서 물음표 제거하기위해 사용
            DispatchQueue.main.async {
                //                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    // TODO: 리셋일때 따로 메서드 생성하기
                    self.products += response.items
                    
                    /// currentStart 계산
                    if self.currentStart + self.display > response.total {
                        self.hasMoreData = false
                    } else{
                        self.currentStart += self.display
                    }
                    self.collectionView.reloadData()
                    self.isLoading = false
                    //                    self?.products = response.items
                    self.totalLabel.text = "\(response.total.decimalString) 개의 검색 결과"
                    //                    self?.collectionView.reloadData()
                case .failure(let error):
                    self.view.makeToast("상품을 불러오는 데 실패했습니다", duration: 2.0, position: .center)
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
        /// fatal error
//        guard indexPath.item < products.count else {
//            return UICollectionViewCell() // 빈셀
//        }
//        guard indexPath.item < products.count else {
//            fatalError("indexPath 범위를 벗어났습니다.")
//        }
//        
        
        guard indexPath.item < products.count else {
            assertionFailure("indexPath.item \(indexPath.item) < products.count \(products.count)")
            return UICollectionViewCell()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureData(products[indexPath.item])
        return cell
    }
}
extension ResultViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("indexPath.row \(indexPath.row)")
        guard products.indices.contains(indexPath.item) else { return }
        if indexPath.row >= products.count - 10 && hasMoreData && !isLoading{
            fetchProducts()
            print(#function)
        }
    }
}

