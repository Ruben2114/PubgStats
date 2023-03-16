//
//  ProfileViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import UIKit

    
class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUserInterface()
        
        title = "Profile"
    }
    
    private let mainContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 0.6
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var firstStackView = makeStackView()
    private lazy var secondStackView = makeStackView()
    private lazy var numberLabel: UILabel = makeLabel()
    private lazy var dateLabel: UILabel = makeLabel()
    private lazy var sessionLabel: UILabel = makeLabel()
    private lazy var number2Label: UILabel = makeLabel()
    private lazy var date2Label: UILabel = makeLabel()
    private lazy var session2Label: UILabel = makeLabel()
    
    
    private func configUserInterface(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(mainContainer)
        mainContainer.setConstraints(
            top: view.topAnchor,
            right: view.rightAnchor,
            bottom: view.bottomAnchor,
            left: view.leftAnchor,
            pTop: 200,
            pBottom: 200
        )
        mainContainer.addSubview(firstStackView)
        firstStackView.setConstraints(
            top: mainContainer.topAnchor,
            right: mainContainer.rightAnchor,
            left: mainContainer.leftAnchor)
        firstStackView.spacing = 5
        
        mainContainer.addSubview(secondStackView)
        secondStackView.setConstraints(
            top: mainContainer.topAnchor,
            right: mainContainer.rightAnchor,
            left: mainContainer.leftAnchor,
            pTop: 10)
        secondStackView.spacing = 5

        [numberLabel, dateLabel, sessionLabel].forEach { firstStackView.addArrangedSubview($0)
        }
        [number2Label, date2Label, session2Label].forEach { secondStackView.addArrangedSubview($0)
        }
    }
    private func makeStackView() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        return stack
    }
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .systemBlue
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.textColor = .white
        return label
    }
}

