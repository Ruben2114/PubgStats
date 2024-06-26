//
//  ChartCollectionView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 17/7/23.
//

import Foundation
import UIKit
import Combine

protocol ChartViewData {
    var charts: [PieChartViewDataRepresentable] { get }
    var chartSelectedIndex: Int { get }
}

struct DefaultChartViewData: ChartViewData {
    var charts: [PieChartViewDataRepresentable]
    var chartSelectedIndex: Int
}

enum ChartCollectionViewState {
    case didChangeHeight(_ height: CGFloat)
    case didSelectChart(Int)
    case didTapAverageTooltip((String, String)?)
}

final class ChartCollectionView: UICollectionView {
    private let layout: ZoomAndSnapFlowLayout = ZoomAndSnapFlowLayout()
    private var chartsData: [PieChartViewDataRepresentable] = []
    private var chartSelectedIndex: Int = 0
    private var subject = PassthroughSubject<ChartCollectionViewState, Never>()
    public lazy var publisher: AnyPublisher<ChartCollectionViewState, Never> = {
        return subject.eraseToAnyPublisher()
    }()

    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    func configureViews(_ representable: ChartViewData) {
        self.chartSelectedIndex = representable.chartSelectedIndex
        chartsData = representable.charts
        self.reloadData()
        self.setSelectedChart(chartSelectedIndex)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [ weak self] in
            self?.setMaxHeight()
        }
    }
}

private extension ChartCollectionView {
    var cellIdentifier: String {
        String(describing: type(of: ChartCollectionViewCell()))
    }
    
    func setupView() {
        self.registerCell()
        self.addLayout()
        self.decelerationRate = .fast
        self.delegate = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
    
    func registerCell() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func addLayout() {
        let itemWidth = getItemWidth()
        layout.setItemSize(CGSize(width: itemWidth, height: 2000))
        layout.setMinimumLineSpacing(8)
        self.collectionViewLayout = layout
    }
    
    func getItemWidth() -> CGFloat {
        let horizontalPading = CGFloat(24)
        let width = UIScreen.main.bounds.size.width - horizontalPading
        return width
    }
    
    func setSelectedChart(_ transactionSelected: Int) {
        let indexPath = IndexPath(item: transactionSelected, section: 0)
        self.layoutIfNeeded()
        self.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func setMaxHeight() {
        var maxHeight: CGFloat = 0
        let bottomPadding: CGFloat = 16
        let bottomViewSpaccing: CGFloat = 8
        let totalSpacing = bottomPadding + bottomViewSpaccing
        self.visibleCells.forEach {
            guard let contentHeihgt = $0.viewWithTag(1)?.frame.height else { return }
            maxHeight = max(contentHeihgt + totalSpacing, maxHeight)
        }
        subject.send(.didChangeHeight(maxHeight))
    }
    
    func endScrollingAndSelectChart() {
        guard let indexPath = self.layout.indexPathForCenterRect() else { return }
        chartSelectedIndex = indexPath.item
        subject.send(.didSelectChart(indexPath.item))
    }
}

extension ChartCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chartsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChartCollectionViewCell else { return }
        cell.didTapNewView(collectionView.panGestureRecognizer)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ChartCollectionViewCell else { return UICollectionViewCell() }
        let data = chartsData[indexPath.item]
        cell.configureWith(viewData: data)
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.visibleCells.count > 1 {
            setMaxHeight()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endScrollingAndSelectChart()
    }
}

extension ChartCollectionView: ChartCollectionViewCellDelegate {
    func didTapTooltip(_ text: (String, String)?) {
        subject.send(.didTapAverageTooltip(text))
    }
}
