//
//  KeyboardDisplayable.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 14/3/23.
//

import Combine
import UIKit

protocol KeyboardDisplayable: AnyObject {
    var cancellable: Set<AnyCancellable> { get set}
}

extension KeyboardDisplayable where Self : UIViewController {
    
    func configKeyboardSubscription(mainScrollView: UIScrollView) {
        keyboardWillShow(mainScrollView: mainScrollView)
        keyboardWillHide(mainScrollView: mainScrollView)
        hideKeyboardsWithScrollView(mainScrollView: mainScrollView)
    }
    
    private func keyboardWillShow(mainScrollView: UIScrollView) {
        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] notification in
                self?.addExtraSpaceToScrollView(
                    mainScrollView: mainScrollView,
                    notification: notification)
            }.store(in: &cancellable)
    }
    
    private func addExtraSpaceToScrollView(
        mainScrollView: UIScrollView,
        notification: NotificationCenter.Publisher.Output
    ){
        let keyboardFrameEndUserInfoKey = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        let keyboardSize = (keyboardFrameEndUserInfoKey as? NSValue)?.cgRectValue
        guard let keyboardSafeSize = keyboardSize else { return }
        addSpaceToScrollView(withScroll: mainScrollView, withSize: keyboardSafeSize)
    }
    
    private func addSpaceToScrollView(
        withScroll mainScrollView: UIScrollView,
        withSize keyboardSafeSize: CGRect
    ) {
        let safeAreaBottom = view.safeAreaInsets.bottom
        let contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardSafeSize.height - safeAreaBottom + 10,
            right: 0)
        
        mainScrollView.contentInset = contentInset
        mainScrollView.scrollIndicatorInsets = contentInset
    }
    
    private func hideKeyboardsWithScrollView(mainScrollView: UIScrollView){
        mainScrollView.keyboardDismissMode = .interactive
    }
    
    private func keyboardWillHide(mainScrollView: UIScrollView) {
        NotificationCenter
            .default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] notification in
                self?.resetScrollView(mainScrollView: mainScrollView)
        }.store(in: &cancellable)
    }
    
    private func resetScrollView(mainScrollView: UIScrollView) {
        mainScrollView.contentInset = .zero
        mainScrollView.scrollIndicatorInsets = .zero
    }
}

