//
//  VersatilCardView.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit
import Foundation
import Combine

public final class VersatilCardView: XibView {
    
    @IBOutlet private weak var contentView: UIStackView!
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
        configureImage()
        configureLabels()
    }
}

private extension VersatilCardView {
    
    func configureLabels() {
        titleLabel.text = representable?.title
        subtitleLabel.text = representable?.subTitle
    }
    
    func configureImage() {
        guard let image = representable?.customImageView else { return }
        imageView.image = UIImage(systemName: image)
    }
    
    func configureView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        contentView.addGestureRecognizer(gesture)
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    @objc func didTapCard() {
        subject.send()
    }
}
