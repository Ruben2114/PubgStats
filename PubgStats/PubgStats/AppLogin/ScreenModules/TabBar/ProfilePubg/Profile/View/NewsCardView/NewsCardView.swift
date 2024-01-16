//
//  NewsCardView.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit
import Foundation
import Combine

public final class NewsCardView: XibView {
    
    @IBOutlet private weak var contentView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    private var representable: NewsCardRepresentable?
    private var subscriptions = Set<AnyCancellable>()
    private var subject = PassthroughSubject<Void, Never>()
    lazy var publisher: AnyPublisher<Void, Never> = {
        return subject.eraseToAnyPublisher()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func setupVersatilCard(_ representable: NewsCardRepresentable) {
        self.representable = representable
        configureRightImage()
        configureLabels()
    }
}

private extension NewsCardView {
    
    func configureLabels() {
        titleLabel.text = representable?.title
        subtitleLabel.text = representable?.subTitle
    }
    
    func configureRightImage() {
        guard let rightView = representable?.customImageView else { return }
        imageView.image = UIImage(systemName: rightView)
    }
    
    func configureView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        contentView.addGestureRecognizer(gesture)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowOpacity = 0.2
    }
    
    @objc func didTapCard() {
        subject.send()
    }
}
