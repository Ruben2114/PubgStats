//
//  SettingsViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit
import MessageUI
import Combine

final class SettingsViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return tableView
    }()
    private lazy var bottomSheetView: BottomSheetView = {
        BottomSheetView()
    }()
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: SettingsViewModel
    private var settingsField: [SettingsField] = []
   
    init(dependencies: SettingsDependencies) {
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        bind()
        viewModel.viewDidLoad()
    }
}

private extension SettingsViewController {
    func setAppearance() {
        titleNavigation("settingsTabBarItem".localize())
        configureImageBackground("backgroundAirDrop")
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:
                break
            case .showFields(let fields):
                self?.settingsField = fields
                self?.tableView.reloadData()
            case .showErrorDelete:
                self?.presentAlert(message: "errorDeletePlayer".localize(), title: "Error", action: [.accept(nil)])
            }
        }.store(in: &cancellable)
    }
}

extension SettingsViewController: MessageDisplayable{ }
extension SettingsViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        guard error == nil else{return}
        switch result{
        case .cancelled:
            controller.dismiss(animated: true)
        case .saved:
            break
        case .sent:
            presentAlertTimer(message: "mailComposeControllerSent".localize(), title: "", timer: 1)
        case .failed:
            presentAlert(message: "mailComposeControllerFailed".localize(), title: "Error", action: [.accept(nil)])
        @unknown default:
            presentAlert(message: "mailComposeControllerDefault".localize(), title: "Error", action: [.accept(nil)])
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsField.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let settingsField = settingsField[indexPath.section]
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .black.withAlphaComponent(0.8)
        cell.selectionStyle = .none
        var listContent = UIListContentConfiguration.cell()
        listContent.textProperties.font = UIFont(name: "AmericanTypewriter-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        listContent.textProperties.color = .white
        listContent.text = settingsField.title()
        listContent.image =  UIImage(systemName: settingsField.icon())
        listContent.imageProperties.tintColor = UIColor(red: 255/255, green: 205/255, blue: 61/255, alpha: 1)
        cell.contentConfiguration = listContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch settingsField[indexPath.section] {
        case .help:
            viewModel.goHelp()
        case .email:
            guard MFMailComposeViewController.canSendMail() else{
                return
            }
            let sendMail = MFMailComposeViewController()
            sendMail.setToRecipients(["cervigon21@gmail.com"])
            sendMail.setSubject("sendMailSetSubject".localize())
            sendMail.setMessageBody("", isHTML: true)
            sendMail.mailComposeDelegate = self
            present(sendMail, animated: true, completion: nil)
        case .legal:
            //TODO: change text infoAppViewModel
            bottomSheetView.show(in: self, title: "infoAppViewTitle".localize(), subtitle: "infoAppViewModel".localize())
        case .delete:
            presentAlert(message: "alertDeleteProfile".localize(),
                         title: "settingsFieldDelete".localize(),
                         action: [.accept({ [weak self] in self?.viewModel.deleteProfile() }),
                                  .cancel(nil)]
            )
        }
    }
}
