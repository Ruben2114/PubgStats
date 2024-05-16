//
//  SpinnerDisplayable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 10/3/23.
//

import UIKit

protocol LoadingPresentationDisplayable: AnyObject {
    func showLoading()
    func hideLoading()
}

extension LoadingPresentationDisplayable where Self: UIViewController{
    func showLoading(){
        guard doesNotExistAnotherSpinner else {return}
        configureLoading()
    }
    
    private func configureLoading(){
        let containerView = UIView()
        containerView.tag = LoadingTag.tagIdentifierSpinner
        parentView.addSubview(containerView)
        containerView.fillSuperView()
        containerView.backgroundColor = .black
        addSpinnerIndicatorToContainer(containerView: containerView)
    }
    
    private func addSpinnerIndicatorToContainer(containerView: UIView){
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.startAnimating()
        containerView.addSubview(spinner)
        spinner.centerXY()
    }
    
    func hideLoading() {
        if let foundView = parentView.viewWithTag(LoadingTag.tagIdentifierSpinner){
            foundView.removeFromSuperview()
        }
    }
    private var doesNotExistAnotherSpinner: Bool {
        parentView.viewWithTag(LoadingTag.tagIdentifierSpinner) == nil
    }
    private var parentView: UIView {
        navigationController?.view ?? view
    }
}

struct LoadingTag {
    static let tagIdentifierSpinner = 123
}
