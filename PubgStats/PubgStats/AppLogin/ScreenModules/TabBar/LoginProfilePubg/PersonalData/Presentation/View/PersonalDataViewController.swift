//
//  PersonalDataViewController.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 16/3/23.
//

import UIKit

protocol PersonalDataViewControllerCoordinator: AnyObject { }

class PersonalDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Personal Data"
        // Do any additional setup after loading the view.
    }

}
