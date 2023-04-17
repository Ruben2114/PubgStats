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
        title = "Ajustes"
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

extension SettingsViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        guard error == nil else{
            print("Ha ocurrido un problema")
            return
        }
        switch result{
        case .cancelled:
            print("Cancelado")
        case .saved:
            print("Guardado")
        case .sent:
            print("Enviado con éxito")
        case .failed:
            print("Ha fallado")
        @unknown default:
            print("Error inesperado")
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.itemsSettings.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsSettings[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let settingContent = viewModel.itemsSettings[indexPath.section][indexPath.row]
        let value = viewModel.imageSettings[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        var listContent = UIListContentConfiguration.cell()
        listContent.textProperties.font = UIFont.systemFont(ofSize: 20)
        listContent.text = settingContent
        listContent.image =  UIImage(systemName: value)
        cell.contentConfiguration = listContent
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            viewModel.goHelp()
        case (0, 1):
            guard MFMailComposeViewController.canSendMail() else{
                return
            }
            let sendMail = MFMailComposeViewController()
            sendMail.setToRecipients(["cervigon21@gmail.com"])
            sendMail.setSubject("Correo de prueba")
            sendMail.setMessageBody("", isHTML: true)
            sendMail.mailComposeDelegate = self
            present(sendMail, animated: true, completion: nil)
        case (0, 2):
            viewModel.infoDeveloper()
            print("ir a otra vista con una tabla y poner mis datos y el cv para descargar")
        case (1, 0):
            viewModel.deleteProfile()
        default:
            break
        }
    }
}

