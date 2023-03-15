//
//  ContactViewController.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//

import UIKit

final class ContactViewController: UIViewController {
    
    
    
    //TODO: no se ve el boton por el label ocupa la pantalla entera mirar debug
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configConstraints()
    }
    private let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Mi informacion\n\nRecien graduado en desarrollador de aplicacion IOS, con cnocimientoen en....\n\nSi tienes alguna duda contacta a traves de este correo"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "Contact"
    }
    private func configConstraints() {
        view.addSubview(containerStackView)
        containerStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        containerStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        [titleLabel, acceptButton].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }


}
