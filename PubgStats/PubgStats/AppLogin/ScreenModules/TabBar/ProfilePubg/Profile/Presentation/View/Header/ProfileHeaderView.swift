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
    case didTapHelpTooltip
}

final class ProfileHeaderView: XibView {
    @IBOutlet private weak var titleGraph: UILabel!
    @IBOutlet private weak var containerChips: UIStackView!
    @IBOutlet private weak var iconHelpImage: UIImageView!
    
    private var cancellable = Set<AnyCancellable>()
    private var subject = PassthroughSubject<ProfileHeaderViewState, Never>()
    public lazy var publisher: AnyPublisher<ProfileHeaderViewState, Never> = {
        return subject.eraseToAnyPublisher()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension ProfileHeaderView {
    func configureViews() {
        configureChips()
        configureImage()
        titleGraph.text = "Modos de juego"
    }
    
    func configureImage() {
        iconHelpImage.isUserInteractionEnabled = true
        iconHelpImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTooltip)))
    }
    
    func configureChips()  {
        //TODO: poner localized
        let chipModes = getChipButton(viewData: Chip.ViewData(text: "Modes", style: .active, type: .onlyText), type: .modes)
        chipModes.publisher.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.subject.send(.didSelectButton(.modes))
        }.store(in: &cancellable)
        
        let chipWeapon = getChipButton(viewData: Chip.ViewData(text: "Weapon", style: .active, type: .onlyText), type: .weapon)
        chipWeapon.publisher.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.subject.send(.didSelectButton(.weapon))
        }.store(in: &cancellable)
        
        let chipSurvival = getChipButton(viewData: Chip.ViewData(text: "Survival", style: .active, type: .onlyText), type: .survival)
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
    
    @objc func didTapTooltip() {
        subject.send(.didTapHelpTooltip)
    }
}
