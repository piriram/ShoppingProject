//
//  RecommendationCollectionCell.swift
//  ShoppingProject
//
//  Created by piri kim on 7/30/25.
//

import UIKit
import Kingfisher

final class RecommendationCollectionCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 8
        return imageView
    }()
    override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView) // 왜 여기는 뷰.가아니라 컨텐츠뷰.?
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureData(_ product: Product){
        
        if let image = URL(string: product.image){
            imageView.kf.setImage(with: image)
        }
    }
}
