//
//  ProductCollectionViewCell.swift
//  ShoppingProject
//
//  Created by piri kim on 7/26/25.
//
import UIKit
import SnapKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {
    
    let productImageView = UIImageView()
    let mallLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
        
        mallLabel.font = .systemFont(ofSize: 11)
        mallLabel.textColor = .gray
        
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .white
        
        priceLabel.font = .boldSystemFont(ofSize: 14)
        priceLabel.textColor = .white
        
        addSubview(productImageView)
        addSubview(mallLabel)
        addSubview(titleLabel)
        addSubview(priceLabel)
    }
    
    func configureLayout() {
        productImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(4)
            $0.height.equalTo(productImageView.snp.width)
            
        }
        
        mallLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mallLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(8)
            
        }
        
    }
    
    func configureData(_ product: Product) {
        if let url = URL(string: product.image) {
            productImageView.kf.setImage(with: url)
        }
        mallLabel.text = product.mallName
        titleLabel.text = product.title
        priceLabel.text = product.lprice
    }
}
