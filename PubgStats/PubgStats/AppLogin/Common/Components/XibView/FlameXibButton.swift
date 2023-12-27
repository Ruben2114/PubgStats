//
//  FlameXibButton.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 19/10/23.
//

import Foundation
import UIKit

public class FlameXibButton: UIButton {
    
    public static func loadFromXib<T>() -> T? {
        let name = String(describing: type(of: T.self)).components(separatedBy: ".")[0]
        let view = UINib(nibName: name, bundle: Bundle.main).instantiate(withOwner: FlameXibButton.self, options: nil)[0]
        return view as? T
    }
}
