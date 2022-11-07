//
//  UsersNetworking.swift
//  InnocvInterviewProject
//
//  Created by Daniel Flores on 6/11/22.
//

import Foundation



import Foundation


protocol UsersNetworkProtocol: AnyObject {
    func getUsers()
    func deleteUser(id: Int)
    func modifyUser(name: String, birthDate: String, id: Int)
    func addUser(name: String, birthDate: String)
}

class UsersNetwork: UsersNetworkProtocol {
    
    weak var view: UsersView?
    weak var detailView: UserDetailsView?
    
    // MARK: - Public methods
    // MARK: -
    // Método para descargar los datos de generalInfo
    func getUsers() {
        self.view?.showLoading()
        self.view?.removeUsers()
        UserServices.getUsers()
            .done { users in
                print("Tenemos usuarios \(users)")
                self.view?.setUsers(users: users)
            }
            .catch { error in
                print("Error \(error)")
                self.view?.showServiceError(error)
            }
            .finally {
                self.view?.hideLoading()
            }
      
    }
    
    func deleteUser(id: Int) {
        self.view?.showLoading()
        UserServices.deleteUser(id: id)
            .done {
                print("usuario Borrado")
                self.getUsers()
            }
            .catch { error in
                print("Error \(error)")
                self.view?.showServiceError(error)
            }
            .finally {
                self.view?.hideLoading()
            }
    }
    
    func modifyUser(name: String, birthDate: String, id: Int) {
        self.view?.showLoading()
        UserServices.modifyUser(name: name, birthDate: birthDate, id: id)
            .done {
                print("Usuario modificado")
                self.detailView?.modifiedUser()
            }
            .catch { error in
                self.detailView?.showServiceError(error)
            }
            .finally {
                self.detailView?.hideLoading()
            }
    }
    
    func addUser(name: String, birthDate: String) {
        self.view?.showLoading()
        UserServices.postUser(name: name, birthDate: birthDate)
            .done {
                print("Usuario añadido")
                self.detailView?.addedNewUser()
            }
            .catch { error in
                self.detailView?.showServiceError(error)
            }
            .finally {
                self.detailView?.hideLoading()
            }
    }
    
}

