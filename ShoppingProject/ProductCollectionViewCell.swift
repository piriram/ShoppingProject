//
//  ProductCollectionViewCell.swift
//  ShoppingProject
//
//  Created by piri kim on 7/26/25.
//
import UIKit
import SnapKit
import Kingfisher
// TODO: 버튼 하트에 제스처 넣기
class ProductCollectionViewCell: UICollectionViewCell {
    
    let productImageView = UIImageView()
    let mallLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.black.cgColor
        button.isUserInteractionEnabled = true
        return button
    }()
    var onLikeTapped: (() -> Void)? // 외부에 이벤트 전달함
    let spacing:CGFloat = 4
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func heartTapped(){
        print("tapped")
        onLikeTapped?()
        
    }
    func configureUI() {
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 16
        productImageView.clipsToBounds = true
        
        
        mallLabel.font = .systemFont(ofSize: 12)
        mallLabel.textColor = .gray
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .white
        
        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textColor = .white
        
        
        
        addSubview(productImageView)
        addSubview(mallLabel)
        addSubview(titleLabel)
        addSubview(priceLabel)
        contentView.addSubview(heartButton)
        
        heartButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)


    }
    func updateLikeButton(isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        heartButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    func configureLayout() {
        productImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
            $0.height.equalTo(productImageView.snp.width)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8) // 패딩이 왜 안먹는걸까?
            
        }
        
        heartButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.bottom.right.equalTo(productImageView).inset(8)
        }

        
        mallLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(spacing + 4)
            $0.leading.equalTo(productImageView.snp.leading).offset(12)
            $0.trailing.equalTo(productImageView.snp.trailing)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mallLabel.snp.bottom).offset(spacing)
            $0.leading.equalTo(mallLabel.snp.leading)
            $0.trailing.equalTo(mallLabel.snp.trailing)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(spacing)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            
        }
        
    }
    
    func configureData(_ product: Product) {
        if let url = URL(string: product.image) {
            productImageView.kf.setImage(with: url)
        }
        mallLabel.text = product.mallName
        titleLabel.text = product.title.removedHtml
        priceLabel.text = product.lprice.decimalString
        
        updateLikeButton(isLiked: product.isLiked ?? false)
    }
}
