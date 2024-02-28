//
//  ChartsInfoView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 17/7/23.
//

import UIKit
import Foundation
import Combine

final class ChartsInfoView: XibView {
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var chartCollectionView: ChartCollectionView!
    @IBOutlet private weak var chartCollectionHeight: NSLayoutConstraint!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    private var subscriptions = Set<AnyCancellable>()
    private var representable: ChartViewData?
    private var subject = PassthroughSubject<(String, String), Never>()
    public lazy var publisher: AnyPublisher<(String, String), Never> = {
        return subject.eraseToAnyPublisher()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setAppearance()
        bind()
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureViewWith(_ representable: ChartViewData) {
        self.representable = representable
        configureViews()
    }
    
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        let index = IndexPath(item: sender.currentPage, section: .zero)
        self.chartCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
}

private extension ChartsInfoView {
    func setAppearance() {
        //TODO: key
        titleLabel.text = "Gráfica por categorias"
        titleLabel.textColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
    }
    
    func bind() {
        bindCollectionView()
    }
    
    func bindCollectionView() {
        chartCollectionView.publisher.sink { [weak self] state in
            switch state {
            case .didChangeHeight(let height):
                self?.chartCollectionHeight.constant = height
            case .didSelectChart(let page):
                self?.pageControl.currentPage = page
                self?.updatePageControlDots()
            case .didTapAverageTooltip:
                self?.subject.send(("Kills", "tipos de kills..."))
            }
        }.store(in: &subscriptions)
    }
    
    func configureViews() {
        guard let representable = representable else { return }
        chartCollectionView.configureViews(representable)
        updatePageControl(representable.charts.count)
        chartCollectionView.scrollToItem(at: IndexPath(item: representable.chartSelectedIndex, section: 0),
                                            at: .centeredHorizontally,
                                            animated: false)
    }
    
    func updatePageControl(_ numberOfItems: Int) {
        pageControl.numberOfPages = numberOfItems
        pageControl.isHidden = numberOfItems <= 1
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = representable?.chartSelectedIndex ?? 0
        updatePageControlDots()
        if #available(iOS 14.0, *) {
            pageControl.backgroundStyle = .minimal
        }
    }
    
    func updatePageControlDots() {
        let indicatorColor: UIColor = .systemGray
        let backgroundColorForPriorIOS14 = UIColor.clear
        let currentIndicatorColor: UIColor = .black
        pageControl.currentPageIndicatorTintColor = currentIndicatorColor
        pageControl.pageIndicatorTintColor = indicatorColor
        let symbolDotConfiguration = UIImage.SymbolConfiguration(pointSize: 8, weight: .regular, scale: .medium)
        let dotFillImage = UIImage(systemName: "circle.fill", withConfiguration: symbolDotConfiguration)
        let dotImage = UIImage(systemName: "circle", withConfiguration: symbolDotConfiguration)
        for index in 0..<pageControl.numberOfPages {
            pageControl.setIndicatorImage(index == pageControl.currentPage ? dotFillImage : dotImage, forPage: index)
        }
    }
}
