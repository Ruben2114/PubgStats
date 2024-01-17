//
//  BottomSheetView.swift
//  PubgStats
//
//  Created by Ruben Rodriguez Cervigon on 15/1/24.
//

import UIKit

final class BottomSheetViewController: UIViewController {
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var topBarView: UIView!
    private var customView: UIView?
   
    override func viewDidLoad() {
        guard let customView = customView else { return }
        self.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        self.addView(customView)
    }
        
    func setBottomSheet(view: UIView) {
        self.customView = view
    }
}

private extension BottomSheetViewController {
    func addView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        view.topAnchor.constraint(equalTo: topBarView.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        view.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
