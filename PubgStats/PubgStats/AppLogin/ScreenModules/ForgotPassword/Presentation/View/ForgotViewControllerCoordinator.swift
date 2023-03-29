//
//  ForgotViewControllerCoordinator.swift
//  PubgStats
//
//  Created by Rubén Rodríguez Cervigón on 15/3/23.
//
import UIKit
import Combine

final class ForgotViewController: UIViewController {
    private lazy var levelLabel = makeLabel(height: 78)
    private lazy var nameLabel = makeLabel(height: 21)
    private lazy var xpLabel = makeLabel(height: 21)
    private lazy var stackStackView = makeStack(space: 5)
    private lazy var labelFirstStackView = makeStackHorizontal(space: 5)
    private lazy var winsLabel = makeLabel(height: 65)
    private lazy var killsLabel = makeLabel(height: 65)
    private lazy var top10sLabel = makeLabel(height: 65)
    private lazy var labelSecondStackView = makeStackHorizontal(space: 5)
    private lazy var gamesPlayedLabel = makeLabel(height: 65)
    private lazy var timePlayedLabel = makeLabel(height: 65)
    private lazy var bestRankedLabel = makeLabel(height: 65)
    private lazy var buttonStackView = makeStack(space: 27)
    private lazy var goKillsData = makeButtonBlue(title: "Datos Muertes")
    private lazy var goWeapons = makeButtonBlue(title: "Datos Armas")
    private lazy var goSurvival = makeButtonBlue(title: "Estadisticas Survival")
    private lazy var goGamesModes = makeButtonBlue(title: "Modos de juego")
    
    var mainScrollView = UIScrollView()
    var contentView = UIView()
    var cancellable = Set<AnyCancellable>()
    private let dependencies: ForgotDependency
    private let viewModel: ForgotViewModel
    
    init(mainScrollView: UIScrollView = UIScrollView(), contentView: UIView = UIView(), cancellable: Set<AnyCancellable> = Set<AnyCancellable>(), dependencies: ForgotDependency) {
        self.mainScrollView = mainScrollView
        self.contentView = contentView
        self.cancellable = cancellable
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScroll()
        configUI()
        configConstraints()
        bind()
    }
    private func bind() {
        xpLabel.text = "11 XP"
        levelLabel.text = "Nivel\n88"
        killsLabel.text = "11\nMuertes"
        top10sLabel.text = "11\nTop10S"
        gamesPlayedLabel.text = "11\nPartidas"
        winsLabel.text = "11\nVictorias"
        timePlayedLabel.text = "11\nTiempo Jugado"
        bestRankedLabel.text = "11\nMejor ranked"
        nameLabel.text = "Leyenda21"
    }
    private func configUI() {
        view.backgroundColor = .systemBackground
        title = "Forgot your password"
        backButton(action: #selector(backButtonAction))
        stackStackView.backgroundColor = .systemCyan
    }
    private func configConstraints() {
        contentView.addSubview(levelLabel)
        levelLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 7).isActive = true
        levelLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 22).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(xpLabel)
        xpLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16).isActive = true
        xpLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(stackStackView)
        stackStackView.topAnchor.constraint(equalTo: xpLabel.bottomAnchor, constant: 30).isActive = true
        stackStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        stackStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        [labelFirstStackView, labelSecondStackView].forEach {
            stackStackView.addArrangedSubview($0)
        }
        
        [winsLabel,killsLabel, top10sLabel].forEach {
            labelFirstStackView.addArrangedSubview($0)
        }
        
        [gamesPlayedLabel,timePlayedLabel,bestRankedLabel].forEach {
            labelSecondStackView.addArrangedSubview($0)
        }
        contentView.addSubview(buttonStackView)
        buttonStackView.topAnchor.constraint(equalTo: stackStackView.bottomAnchor, constant: 61).isActive = true
        buttonStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        [goKillsData, goWeapons, goSurvival, goGamesModes].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
    }
    @objc func backButtonAction() {
        viewModel.backButton()
    }
    private func makeLabel(height: CGFloat) -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.setHeightConstraint(with: height)
        return label
    }
    //enviar un correo con la nueva contraseña
    //o decir que esta funcionalidad no esta todavia
}
extension ForgotViewController: MessageDisplayable { }
extension ForgotViewController: ViewScrollable {}

