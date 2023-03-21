//
//  ProfileViewModel.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 21/3/23.
//

import Foundation
import UIKit

final class ProfileViewModel {
    //elegir entre mostrar botonreistro o boton perfil
    
    func chooseButton(buttonLink: UIButton, buttonStat: UIButton ) {
        if buttonLink.superview == nil {
            buttonLink.isHidden = false
            buttonStat.isHidden = true
        } else {
            buttonLink.isHidden = true
            buttonStat.isHidden = false
        }
    }
}



