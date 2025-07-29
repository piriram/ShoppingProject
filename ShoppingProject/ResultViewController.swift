//
//  ResultViewController.swift
//  ShoppingProject
//
//  Created by piri kim on 7/26/25.
//
// MARK: 검색 결과 리스트 화면
// TODO: 아이패드도 대응해보기
// TODO: fatal Error를 어떻게 더 안전하게 만들 수 있을지 고민해보기
import UIKit
import SnapKit
import Toast

class ResultViewController: UIViewController {
    
    var keyword: String = ""
    private var products: [Product] = []
    private let totalLabel = UILabel()
    private let sortView = SortButtonView()
    var display = 100
    var currentStart = 1
    var recommandation: [Product] = []
    
    
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
        collectionView.prefetchDataSource = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCell")
        return collectionView
    }()
    
    lazy var recommendationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 1
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.backgroundColor = .clear
        
        cv.register(RecommendationCollectionCell.self, forCellWithReuseIdentifier: "RecommendationCell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        configureToast()
        title = keyword
        
        configureUI()
        fetchProducts()
        
        sortView.onSortSelected = { [weak self] sortType in
            self?.isReset = true
            self?.collectionView.setContentOffset(.zero, animated: true)
            self?.fetchProducts()
        }
        fetchRecommendProducts(keyword: "쥬토피아")
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
        view.addSubview(recommendationCollectionView)
        sortView.snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(sortView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
//            $0.bottom.equalTo(recommendationCollectionView.snp.top).offset(-8)
        }
        
        
        recommendationCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
            
        }
    }
    
    func validateTotalNum(_ response: ProductTotal) {
        let currentText = self.totalLabel.text ?? ""
        let currentNumberString = currentText.components(separatedBy: " ").first?.replacingOccurrences(of: ",", with: "")
        let currentTotal = Int(currentNumberString ?? "") ?? 0
        
        if currentTotal < response.total {
            self.totalLabel.text = "\(response.total.decimalString) 개의 검색 결과"
        }
    }
    func fetchRecommendProducts(keyword: String) {
        NaverShoppingAPI.shared.fetchAllQueryProducts(query: keyword, display: 10, sort: SortType.sim.rawValue, start: 1 ){ [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.recommandation = response.items
                    self.recommendationCollectionView.reloadData()
                case .failure(let error):
                    let message: String
                    if let error = error as? NaverAPIError {
                        message = error.message
                    }else{
                        message = error.localizedDescription
                    }
                    self.view.makeToast(message,duration: 2.0,position: .center)
                }
            }
        }
    }
    private func fetchProducts() {
        
        
        /// 새로 조회할 때
        if isReset {
            print("isReset = true")
            currentStart = 1
            
            products = []
            /// fatal error 원인?
            collectionView.reloadData()
            
            isReset = false
            
        }
        
        
        NaverShoppingAPI.shared.fetchAllQueryProducts(query: keyword, display: display, sort: sortView.selectedType.rawValue, start: currentStart ){ [weak self] result in
            
            guard let self = self else { return } /// weak self의 순환 참조를 방지하기 위해 옵셔널 체이닝 되던것에서 물음표 제거하기위해 사용
            DispatchQueue.main.async {
                //                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    // TODO: 리셋일때 따로 메서드 생성하기
                    self.products += response.items
                    
                    if  self.currentStart >= 1000{
                       // 이후 과정을 하지않고 토스트 메시지 띄우기
                        self.view.makeToast("더이상 보여줄 상품이 없습니다.", duration: 2.0, position: .center)
                        return
                    }
                    self.currentStart += self.display
                    
                   
                    
                    self.validateTotalNum(response)

                    
                    self.collectionView.reloadData()
                    print("products count : \(self.products.count)")
                    
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
        if collectionView == self.collectionView {
            return products.count
        }
        else{
            return recommandation.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("indexPath \(indexPath.item) | products.count: \(products.count)")
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configureData(products[indexPath.item])
            
            cell.onLikeTapped = { [weak self] in
                guard let self = self else { return }
                self.products[indexPath.item].isLiked.toggle()
                print("self.products[indexPath.item].isLiked: \(String(describing: self.products[indexPath.item].isLiked))")
                cell.updateLikeButton(isLiked: self.products[indexPath.item].isLiked)
    //            self.collectionView.reloadItems(at: [indexPath])
    //            cell.updateLikeButton(isLiked: self.products[indexPath.item].isLiked ?? false)
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCell", for: indexPath) as! RecommendationCollectionCell
            cell.configureData(recommandation[indexPath.item])
            return cell
        }
       
        
        
       
    }
}

extension ResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxIndex = indexPaths.map({ $0.item }).max() else { return }
        if maxIndex >= products.count - 10 {
            fetchProducts()
        }
    }
}
