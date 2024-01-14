//
//  GraphInfoModesView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 17/12/23.
//

import UIKit
import Foundation
import Combine

enum GraphInfoModesViewState: State {
    case didSelectButton(ProfileButton)
    case didTapHelpTooltip
}

final class GraphInfoModesView: XibView {
    
    @IBOutlet private weak var graphFirst: DoubleChartBarAdapter!
    @IBOutlet private weak var graphSecond: DoubleChartBarAdapter!
    @IBOutlet private weak var graphThird: DoubleChartBarAdapter!
    @IBOutlet private weak var containerChips: UIStackView!
    
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
    
    func configureWith(representable: GraphInfoModesRepresentable?) {
        configureGraph(representable: representable)
    }
}

private extension GraphInfoModesView {
    func configureViews() {
        configureChips()
    }
    
    func configureGraph(representable: GraphInfoModesRepresentable?) {
        graphFirst.configureView(representable?.firstGraph)
        graphSecond.configureView(representable?.secondGraph)
        graphThird.configureView(representable?.thirdGraph)
    }
    
    func configureChips()  {
        //TODO: poner localized y crear modo .discrete que tenga sombreado el chip
        getChipButton(viewData: Chip.ViewData(text: "Solo", style: .active, type: .onlyText))
        getChipButton(viewData: Chip.ViewData(text: "Duo", style: .active, type: .onlyText))
        getChipButton(viewData: Chip.ViewData(text: "Squad", style: .active, type: .onlyText))
    }
    
    func getChipButton(viewData: Chip.ViewData) {
        let button: Chip = Chip.loadFromXib() ?? Chip()
        button.setViewData(viewData: viewData)
        button.isEnabled = true
        let chip = button.embedIntoCenter()
        containerChips.addArrangedSubview(chip)
    }
}
