//
//  SettingsViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit
import MessageUI

final class SettingsViewController: UIViewController {
    private lazy var tableView = makeTableViewGroup()
    private let dependencies: SettingsDependency
    private let viewModel: SettingsViewModel
   
    init(dependencies: SettingsDependency) {
        self.dependencies = dependencies
        self.viewModel = dependencies.resolve()
        super.init(nibName: nil, bundle: nil)
    }
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configConstraints()
    }
    
    private func configUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "settingsDataViewControllerTitle".localize()
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func configConstraints() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
extension SettingsViewController: MessageDisplayable{ }
extension SettingsViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        guard error == nil else{return}
        switch result{
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            presentAlertTimer(message: "mailComposeControllerSent".localize(), title: "", timer: 1)
        case .failed:
            presentAlert(message: "mailComposeControllerFailed".localize(), title: "Error")
        @unknown default:
            presentAlert(message: "mailComposeControllerDefault".localize(), title: "Error")
        }
    }
}
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settingsField.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingsField[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let settingsField = viewModel.settingsField[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        var listContent = UIListContentConfiguration.cell()
        listContent.textProperties.font = UIFont.systemFont(ofSize: 20)
        listContent.text = settingsField.title()
        listContent.image =  UIImage(systemName: settingsField.icon())
        cell.contentConfiguration = listContent
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsField = viewModel.settingsField[indexPath.section][indexPath.row]
        switch settingsField {
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
            viewModel.infoDeveloper()
        case .delete:
            viewModel.deleteProfile()
        }
    }
}
