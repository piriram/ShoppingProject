//
//  SortButtonView.swift
//  ShoppingProject
//
//  Created by piri kim on 7/27/25.
//
import UIKit
import SnapKit

final class SortButtonView: UIView {
    
    var selectedType: SortType = .accuracy {
        didSet {
            updateBtnState()
        }
    }

    private var btns: [SortType: UIButton] = [:]
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) { // 코드 기반 UI 생성
        super.init(frame: frame)
        configure()
    }
    
    func configure() {
        configureUI()
        configureBtn()
    }
    
    required init?(coder: NSCoder) { // 인터페이스 빌더 기반 UI 생성
        super.init(coder: coder)
        configure()
    }
    
    private func configureUI() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    
    private func configureBtn() {
        SortType.allCases.forEach { type in
            let btn = createBtn(for: type)
            btns[type] = btn
            stackView.addArrangedSubview(btn)
        }
        updateBtnState()
    }
    
    private func createBtn(for type: SortType) -> UIButton {
        let button = UIButton(type: .system)
        button.configuration = nil
        
        button.setTitle(type.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        
        button.contentEdgeInsets = .init(top: 8, left: 12, bottom: 8, right: 12)
        
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        button.addTarget(self, action: #selector(sortBtnTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func sortBtnTapped(_ sender: UIButton) {
        guard let selected = btns.first(where: { $0.value == sender })?.key else { return }
        selectedType = selected
    }
    
    private func updateBtnState() {
        for (type, btn) in btns {
            let isSelected = (type == selectedType)
            btn.backgroundColor = isSelected ? .white : .clear
            btn.setTitleColor(isSelected ? .black : .white, for: .normal)
        }
    }
}
