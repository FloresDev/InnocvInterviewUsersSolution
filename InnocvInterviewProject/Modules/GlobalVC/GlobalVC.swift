//
//  GlobalVC.swift
//  Safy
//
//  Created by Jorge Suárez on 6/5/22.
//  Copyright © 2022 Safy. All rights reserved.
//

import UIKit

enum SpinnerAction {
    case add
    case remove
}

protocol GlobalView: AnyObject {
    func showLoading()
    func hideLoading()
    func showServiceError(_ error: Error)
}

class GlobalVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func handleError(_ error: Error) {
        alert(msg: error.localizedDescription)
    }
    
    // MARK: Alerts
    func alert(msg: String, title: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let vc = UIAlertController(
            title: title ?? "",
            message: msg,
            preferredStyle: .alert
        )
        vc.addAction(.init(title: "Aceptar", style: .default, handler: handler))
        self.present(vc, animated: true)
    }
}

// MARK: - Spinner
private func manageSpinner(inside view: UIView, action: SpinnerAction, yOffset: CGFloat? = nil) {
    
    switch action {
    case .add:
        let spinner = UIActivityIndicatorView()
        let spinnerView = SpinnerView()
        view.addSubview(spinnerView)
        
        spinnerView.addSubview(spinner)
        spinnerView.alpha = 0
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        spinnerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yOffset ?? 0).isActive = true
        spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor).isActive = true
        spinner.color = .black
        spinner.startAnimating()
        
        UIView.animate(withDuration: 1) { spinnerView.alpha = 1 }
    case .remove:
        let spinnerView = view.subviews.filter({ $0.isKind(of: SpinnerView.self) })
        spinnerView.forEach { spinner in
            UIView.animate(withDuration: 0.2, animations: {
                spinner.alpha = 0
            }, completion: { (success) in
                guard success else { return }
                spinner.removeFromSuperview()
            })
        }
    }
}



// MARK: - Extensions
// MARK: -
// MARK: - Global View
// MARK: -
extension GlobalVC: GlobalView {
    
    func showLoading() {
        manageSpinner(inside: view, action: .add)
    }
    func hideLoading() {
        manageSpinner(inside: view, action: .remove)
    }
    
    func showServiceError(_ error: Error) {
        handleError(error)
    }
}
