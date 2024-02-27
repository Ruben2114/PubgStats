//
//  ProfileHeaderView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 17/12/23.
//

import UIKit
import Foundation
import Combine

enum ProfileButton: CaseIterable {
    case modes
    case weapon
    
    func getTitle() -> String {
        switch self {
        case .modes: return "profileHeaderModes"
        case .weapon: return "profileHeaderWeapon"
        }
    }
}

enum ProfileHeaderViewState: State {
    case didSelectButton(ProfileButton)
}

final class ProfileHeaderView: XibView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var namePlayerLabel: UILabel!
    @IBOutlet private weak var platformImage: UIImageView!
    @IBOutlet private weak var levelDescriptionLabel: UILabel!
    @IBOutlet private weak var levelAmountLabel: UILabel!
    @IBOutlet private weak var xpDescriptionLabel: UILabel!
    @IBOutlet private weak var xpAmountLabel: UILabel!
    @IBOutlet private weak var titleDataGeneral: UILabel!
    @IBOutlet private weak var containerChips: UIStackView!
    
    private var cancellable = Set<AnyCancellable>()
    private var subject = PassthroughSubject<ProfileHeaderViewState, Never>()
    public lazy var publisher: AnyPublisher<ProfileHeaderViewState, Never> = {
        return subject.eraseToAnyPublisher()
    }()
    private var representable: ProfileHeaderViewRepresentable?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureView(representable: ProfileHeaderViewRepresentable) {
        self.representable = representable
        configureLabel()
        configureImagePlatform()
    }
}

private extension ProfileHeaderView {
    func configureViews() {
        configureContainer()
        configureChips()
    }
    
    func configureContainer() {
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .black.withAlphaComponent(0.8)
        
        titleDataGeneral.textColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
    }
    
    func configureImagePlatform() {
        if representable?.dataPlayer.platform == "steam" {
            platformImage.image = UIImage(named: "Steam_icon_logo")
        }
    }
    
    func configureLabel() {
        titleDataGeneral.text = "profileHeaderTitleDataGeneral".localize()
        namePlayerLabel.text = representable?.dataPlayer.name
        levelDescriptionLabel.text = "level".localize()
        levelAmountLabel.text = representable?.level
        xpDescriptionLabel.text = "XP"
        xpAmountLabel.text = representable?.xp
    }
    
    func configureChips()  {
        ProfileButton.allCases.forEach { type in
            getChipButton(viewData: Chip.ViewData(text: type.getTitle().localize(), style: .enabled, type: .onlyText), type: type)
        }
    }
    
    func getChipButton(viewData: Chip.ViewData, type: ProfileButton) {
        let button: Chip = Chip.loadFromXib() ?? Chip()
        button.setViewData(viewData: viewData)
        button.isEnabled = true
        button.publisher.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.subject.send(.didSelectButton(type))
        }.store(in: &cancellable)
        containerChips.addArrangedSubview(button)
    }
}
