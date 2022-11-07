//
//  ViewController.swift
//  InnocvInterviewProject
//
//  Created by Daniel Flores on 6/11/22.
//

import UIKit

protocol UsersView: GlobalView {
    func setUsers(users: [User])
    func removeUsers()
}

class UsersVC: GlobalVC {
    
    // MARK: - Outlets/Properties
    // MARK: -
    @IBOutlet weak var tableViewUsers: UITableView! {
        didSet {
            tableViewUsers.dataSource = self
            tableViewUsers.delegate = self
            tableViewUsers.register(UINib(nibName: UsersCell.nibName, bundle: nil), forCellReuseIdentifier: UsersCell.reuseIdentifier)
            tableViewUsers.rowHeight = 116
        }
    }
    
    
    var network = UsersNetwork()
    var users = [User]()
    var selectedUser: User?

    // MARK: - LifeCycle
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        network.view = self
        self.title = "LISTA DE USUARIOS DE LA APP"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        network.getUsers()
    }
    
    // MARK: - Actions
    // MARK: -
    @IBAction func buttonAddUserAction(_ sender: Any) {
      performSegue(withIdentifier: "goToAddUser", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserDetailsVC {
            if segue.identifier == "goToAddUser" {
                destination.fromWhere = .addUser
            }
            if segue.identifier == "goToDetailUser" {
                destination.fromWhere = .detailUser
                destination.user = selectedUser
            }
            
        }
       
    }
}


// MARK: - Extensions - UsersView
extension UsersVC: UsersView {
    func setUsers(users: [User]) {
        self.users = users
        self.tableViewUsers.reloadData()
    }
    
    func removeUsers() {
        self.users.removeAll()
    }
}

// MARK: - Extensions - UITableViewDataSource, UITableViewDelegate
extension UsersVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersCell.reuseIdentifier) as! UsersCell
        let user = users[indexPath.row]
        cell.configureCell(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = users[indexPath.row]
        performSegue(withIdentifier: "goToDetailUser", sender: self)
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let user = users[indexPath.row]
            users.remove(at: indexPath.row)
            network.deleteUser(id: user.id)
        }
    }
    
    
}

