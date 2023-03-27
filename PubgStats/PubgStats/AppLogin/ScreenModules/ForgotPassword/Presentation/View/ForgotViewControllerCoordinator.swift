//
//  ForgotViewControllerCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//
import UIKit

protocol ForgotViewControllerCoordinator {
    
}

final class ForgotViewController: UIViewController {
    private let dependencies: ForgotDependency
    private let viewModel: ForgotViewModel
    
    init(dependencies: ForgotDependency) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Forgot your password"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward.circle.fill"), style: .plain, target: self, action: #selector(backButton))
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func backButton() {
        viewModel.backButton()
    }
    //enviar un correo con la nueva contraseña
    //o decir que esta funcionalidad no esta todavia
}
