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

class SearchViewController: UIViewController,UISearchBarDelegate {
    private let searchBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
