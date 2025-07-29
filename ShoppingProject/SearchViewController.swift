//
//  SearchViewController.swift
//  ShoppingProject
//
//  Created by piri kim on 7/26/25.
//
// MARK: UISearchBar를 포함한 메인 검색화면
// TODO: 2글자 이상 입력시 키보드 리턴으로 화면 전화
// TODO: 검색어를 `ResultViewController로 전달

import UIKit
import SnapKit
import Toast

class SearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToast()
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        title = "영캠러의 쇼핑쇼핑"
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.delegate = self
        view.addSubview(searchBar)
        
    }
    
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }
    private func goResultPage(keyword: String) {
        let vc = ResultViewController()
        vc.keyword = keyword
        vc.isReset = true
        navigationItem.backButtonTitle = ""
        navigationController?.title = keyword
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureToast() {
        var style = ToastStyle()
        style.backgroundColor = .white
        style.messageColor = .black
        ToastManager.shared.style = style
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            self.view.makeToast("검색어를 입력해주세요.", duration: 2.0, position: .center)
            return
        }
        
        guard text.count >= 2 else {
            self.view.makeToast("2글자 이상 입력해주세요.", duration: 2.0, position: .center)
            return
        }
        
        goResultPage(keyword: text)
        searchBar.resignFirstResponder()
    }
}
