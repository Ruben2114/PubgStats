//
//  ItemWeaponDataCollectionViewCell.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 28/3/23.
//

import UIKit

class ItemWeaponDataCollectionViewCell: UICollectionViewCell{
    
    private let mainContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = ViewValues.defaultCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    let categoryMenuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let titleCategoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    override init(frame: CGRect) {
        super .init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI(){
        addSubview(mainContainer)
        mainContainer.fillSuperView(widthPadding: ViewValues.normalPadding)
        mainContainer.addSubview(categoryMenuImageView)
        categoryMenuImageView.fillSuperView()
        configGradientForTitle()
        
        mainContainer.addSubview(titleCategoryLabel)
        titleCategoryLabel.setConstraints(
            right: mainContainer.rightAnchor,
            bottom: mainContainer.bottomAnchor,
            left: mainContainer.leftAnchor,
            pRight: ViewValues.normalPadding,
            pBottom: ViewValues.normalPadding,
            pLeft: ViewValues.normalPadding)
    }
    
    private func configGradientForTitle() {
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = self.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.darkGray.cgColor]
        gradientMaskLayer.locations = [ViewValues.gradientTitleInit, ViewValues.gradientTitleEnd]
        mainContainer.layer.addSublayer(gradientMaskLayer)
    }
}

