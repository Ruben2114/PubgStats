//
//  ProfileHeaderView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 17/12/23.
//

import UIKit
import Foundation
import Combine

enum ProfileButton {
    case modes
    case weapon
    case survival
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
    @IBOutlet private weak var titleGraph: UILabel!
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
        containerView.layer.borderColor = UIColor.systemGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 0.2
    }
    
    func configureImagePlatform() {
        if representable?.dataPlayer.platform == "steam" {
            platformImage.image = UIImage(named: "Steam_icon_logo")
        }
    }
    
    func configureLabel() {
        titleGraph.text = "profileHeaderTitleGraph".localize()
        namePlayerLabel.text = representable?.dataPlayer.name
        levelDescriptionLabel.text = "level".localize()
        levelAmountLabel.text = representable?.level
        xpDescriptionLabel.text = "XP"
        xpAmountLabel.text = representable?.xp
    }
    
    func configureChips()  {
        let chipModes = getChipButton(viewData: Chip.ViewData(text: "profileHeaderModes".localize(), style: .enabled, type: .onlyText), type: .modes)
        chipModes.publisher.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.subject.send(.didSelectButton(.modes))
        }.store(in: &cancellable)
        
        let chipWeapon = getChipButton(viewData: Chip.ViewData(text: "profileHeaderWeapon".localize(), style: .enabled, type: .onlyText), type: .weapon)
        chipWeapon.publisher.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.subject.send(.didSelectButton(.weapon))
        }.store(in: &cancellable)
        
        let chipSurvival = getChipButton(viewData: Chip.ViewData(text: "profileHeaderSurvival".localize(), style: .enabled, type: .onlyText), type: .survival)
        chipSurvival.publisher.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.subject.send(.didSelectButton(.survival))
        }.store(in: &cancellable)
        
        containerChips.addArrangedSubview(chipModes)
        containerChips.addArrangedSubview(chipWeapon)
        containerChips.addArrangedSubview(chipSurvival)
    }
    
    func getChipButton(viewData: Chip.ViewData, type: ProfileButton) -> Chip {
        let button: Chip = Chip.loadFromXib() ?? Chip()
        button.setViewData(viewData: viewData)
        button.isEnabled = true
        return button
    }
}
