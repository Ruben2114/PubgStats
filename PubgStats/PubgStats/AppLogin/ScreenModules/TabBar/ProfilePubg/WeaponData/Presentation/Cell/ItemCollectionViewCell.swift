//
//  ItemCollectionViewCell.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/5/23.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var spLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    
    internal var infoPlayer: [[String]] = [
        ["0\nWinner of best","0d 0h 0m\ntiempo jugado"],
        ["0\nWin1","0\nWinner of best","0\nPartidas","0d 0h 0m\ntiempo jugado"],
        ["0\nWin2","0\nWinner of best","0\nPartidas","0d 0h 0m\ntiempo jugado"]
    ]
    internal var infoPlayer2: [[String]] = [
        ["0\nWin3","0\nWinner of best","0\nPartidas","0d 0h 0m\ntiempo jugado"],
        ["0\nWin4","0\nWinner of best","0\nPartidas","0d 0h 0m\ntiempo jugado"],
        ["0\nWin5","0\nWinner of best","0\nPartidas","0d 0h 0m\ntiempo jugado"]
    ]
    internal var infoPlayer3: [[String]] = [
        ["0\nWin6","0\nWinner of best","0\nPartidas","0d 0h 0m\ntiempo jugado"],
        ["0\nWin7","0\nWinner of best","0\nPartidas","0d 0h 0m\ntiempo jugado"],
        ["0\nWin8","0\nWinner of best","0\nPartidas","0d 0h 0m\ntiempo jugado"]
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configConstraint()
    }
    
    private func configConstraint() {
        for i in 0..<3{
            let subStack = stackView()
            mainStack.addArrangedSubview(subStack)
            if i == 0 {
                for t in 0..<2{
                    let label = labelView(text: infoPlayer[i][t])
                    subStack.addArrangedSubview(label)
                }
            }else {
                for t in 0..<4{
                    let label = labelView(text: infoPlayer[i][t])
                    subStack.addArrangedSubview(label)
                }
            }
            
        }
            
    }
    private func stackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.backgroundColor = .systemGray
        return stack
    }
    private func labelView(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .yellow
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
}
