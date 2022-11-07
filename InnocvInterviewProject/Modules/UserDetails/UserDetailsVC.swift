//
//  UserDetails.swift
//  InnocvInterviewProject
//
//  Created by Daniel Flores on 7/11/22.
//

import UIKit

enum OriginNavigation {
    case addUser
    case detailUser
}

protocol UserDetailsView: GlobalView {
    func addedNewUser()
    func modifiedUser()
}

class UserDetailsVC: GlobalVC {
    
    // MARK: - Outlets/Properties
    // MARK: -
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldBirthDate: UITextField!
    @IBOutlet weak var buttonEditUserOutlet: UIButton!
    
    var user: User?
    var fromWhere: OriginNavigation?
    var network = UsersNetwork()
    
    // MARK: - LifeCycle
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        network.detailView = self
        setView()
    }
    
    // MARK: - Actions
    // MARK: -
    @IBAction func buttonEditUserAction(_ sender: Any) {
        if fromWhere == .detailUser, textFieldName.borderStyle != .roundedRect {
            textFieldName.borderStyle = .roundedRect
            textFieldBirthDate.borderStyle = .roundedRect
            textFieldName.isEnabled = true
            textFieldBirthDate.isEnabled = true
            buttonEditUserOutlet.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
            return
        }
        if fromWhere == .addUser || fromWhere == .detailUser, textFieldName.borderStyle == .roundedRect {
            guard let name = textFieldName.text, let birthDate = textFieldBirthDate.text else { return }
            if name == "" {
                self.alert(msg: "DEBE RELLENAR EL NOMBRE")
                return
            }
            guard let parsedDate = birthDate.formatISODateString() else {
                self.alert(msg: "FORMATO DE FECHA ERRONEO")
                return
                
            }
            if fromWhere == .addUser {
                network.addUser(name: name, birthDate: parsedDate)
                
            }
            
            if fromWhere == .detailUser {
                guard let user = user else {
                    return
                }
                network.modifyUser(name: name, birthDate: parsedDate, id: user.id)
            }
            return
        }
    }
    
    // MARK: - Private Methods
    // MARK: -
    private func setView() {
        guard let fromWhere = fromWhere else {
            return
        }
        
        self.title = fromWhere == .detailUser ? "DETALLE DE USUARIO" : "AÑADIR USUARIO"
        if fromWhere == .addUser {
            buttonEditUserOutlet.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        }
        textFieldName.borderStyle = fromWhere == .detailUser ? .none : .roundedRect
        textFieldBirthDate.borderStyle = fromWhere == .detailUser ? .none : .roundedRect
        textFieldName.isEnabled = fromWhere == .detailUser ? false : true
        textFieldBirthDate.isEnabled = fromWhere == .detailUser ? false : true
        guard let user = user else {
            return
        }
        self.textFieldName.text = user.name ?? "NONAME"
        self.textFieldBirthDate.text = user.birthDate?.formatBirthDateStringDate()
    }
    
}

// MARK: - Extensions - UserDetailsView
// MARK: -
extension UserDetailsVC: UserDetailsView {
    func addedNewUser() {
        alert(msg: "USUARIO AÑADIDO") { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func modifiedUser() {
        alert(msg: "USUARIO MODIFICADO") { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
