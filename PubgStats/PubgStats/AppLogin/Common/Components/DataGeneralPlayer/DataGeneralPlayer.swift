//
//  DataGeneralPlayer.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 12/7/23.
//

import UIKit

struct DataGeneralPlayerRepresentable {
    var percentage: Int
    var percentageLabel: String = "Victorias: "
    var topLabel: String = "Top label: "
    var gamesLabel: String = "Games: "
    var modeLabel: String
    var image: String?
    var dataLabel: DataLabel
}

struct DataLabel {
    var winsLabel: String
    var timePlayedLabel: String
    var killsLabel: String
    var assistsLabel: String
    var knocksLabel: String
    var bestRankedLabel: String
    var gamesPlayedLabel: String
    var dataLabelComplement: DataLabelComplement?
}

struct DataLabelComplement {
    var lalalaal: String = "llalalalala"
    var lalalaal2: String = "llalalalala"
    var lalalaal3: String = "llalalalala"
    var lalalaal4: String = "llalalalala"
    var lalalaal25: String = "llalalalala"
    var lalalaal36: String = "llalalalala"
    var lalalaal37: String = "llalalalala"
}

class DataGeneralPlayer: UIView {
    private lazy var mainStack = createStack()
    lazy var topLabel = createLabel()
    lazy var gamesLabel = createLabel()
    lazy var modeLabel = createLabel()
    var percentageRectangleView = PercentageRectangleView()
    var linesStack: Int = 3
    private var labels: [UILabel] = []
    private var image: UIImage?
    
    func build(data: DataGeneralPlayerRepresentable) {
        configData(data: data)
        let mirror = Mirror(reflecting: data.dataLabel)
        let dataLabelCount = mirror.children.count - 1
        configLinesStack(count: dataLabelCount)
        configUI()
        self.configureLabel(mirror: mirror)
    }
    
    private func configData(data: DataGeneralPlayerRepresentable) {
        //TODO: meter dotos de 5 medallas y depende el porcentaje de victorias se pone una medalla o otra en la image
        image = UIImage(systemName: "star")
        self.percentageRectangleView.percentage = CGFloat(data.percentage)
        self.percentageRectangleView.label.text = "Victorias \(data.percentage) %"
        self.topLabel.text = data.topLabel
        self.gamesLabel.text = data.gamesLabel
        self.modeLabel.text = data.modeLabel
        
    }
    
    private func configLinesStack(count: Int) {
        if count == 7 {
            linesStack = 2
        } else {
            linesStack = 4
        }
    }
    
    private func configUI() {
        self.backgroundColor = .systemGray
        self.layer.cornerRadius = 15
        
        let image = UIImageView(image: image)
        image.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(image)
        image.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        self.addSubview(gamesLabel)
        gamesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        gamesLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10).isActive = true
        
        self.addSubview(topLabel)
        topLabel.topAnchor.constraint(equalTo: gamesLabel.bottomAnchor, constant: 3).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: gamesLabel.leadingAnchor).isActive = true
        
        self.addSubview(modeLabel)
        modeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        modeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        percentageRectangleView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(percentageRectangleView)
        percentageRectangleView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 3).isActive = true
        percentageRectangleView.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor).isActive = true
        percentageRectangleView.trailingAnchor.constraint(equalTo: modeLabel.leadingAnchor).isActive = true
        percentageRectangleView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(mainStack)
        mainStack.topAnchor.constraint(equalTo: percentageRectangleView.bottomAnchor, constant: 10).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        for e in 0..<linesStack{
            let newStack = UIStackView()
            newStack.axis = .horizontal
            newStack.alignment = .center
            newStack.translatesAutoresizingMaskIntoConstraints = false
            mainStack.addArrangedSubview(newStack)
            
            newStack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            newStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            
            if e % 2 == 0 {
                cells(numbers: 3, stack: newStack, section: e)
            } else {
                cells(numbers: 4, stack: newStack, section: e)
            }
            
            if e == linesStack - 1 {
                newStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
            } else {
                let separador = UIView()
                separador.backgroundColor = .black
                separador.translatesAutoresizingMaskIntoConstraints = false
                mainStack.addArrangedSubview(separador)
                separador.heightAnchor.constraint(equalToConstant: 1).isActive = true
                separador.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 20).isActive = true
                separador.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -20).isActive = true
            }
        }
    }
    
    private func cells(numbers: Int, stack: UIStackView, section: Int) {
        for _ in 0..<numbers {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            stack.addArrangedSubview(label)
            labels.append(label)
        }
    }
    
    func configureLabel(mirror: Mirror) {
        for (index, child) in mirror.children.enumerated() {
            if index < labels.count {
                if let key = child.label, let value: String = child.value as? String {
                    labels[index].setTextLineBreak(key: key.localize(), value: value, fontSize: labels[index].font.pointSize)
                }
            }
        }
    }
}


