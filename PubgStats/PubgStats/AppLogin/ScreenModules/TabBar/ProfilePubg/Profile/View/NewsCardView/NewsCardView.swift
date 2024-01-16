//
//  VersatilCardView.swift
//  UIOneComponents
//
//  Created by Ruben Rodriguez Cervigon on 20/5/23.
//

import UIKit
import Foundation
import Combine

public final class VersatilCardView: XibView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    private var representable: VersatilCardRepresentable?
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
    
    func setupVersatilCard(_ representable: VersatilCardRepresentable) {
        self.representable = representable
        configureRightImage()
        configureLabels()
    }
}

private extension VersatilCardView {
    
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

protocol VersatilCardRepresentable {
    var title: String { get }
    var subTitle: String? { get }
    var customImageView: String? { get }
}

struct DefaultVersatilCard: VersatilCardRepresentable {
    var title: String
    var subTitle: String?
    var customImageView: String?
    
    public init(title: String,
                subTitle: String? = nil,
                customImageView: String? = nil){
        self.title = title
        self.subTitle = subTitle
        self.customImageView = customImageView
    }
}
