//
//  UsersCell.swift
//  InnocvInterviewProject
//
//  Created by Daniel Flores on 6/11/22.
//

import UIKit

class UsersCell: UITableViewCell {

    // MARK: - Properties
    // MARK: -
    
    @IBOutlet weak var labelInitials: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBirthDate: UILabel!
    
    class var reuseIdentifier: String {
        return "UsersCellIdentifier"
    }
    class var nibName: String {
        return "UsersCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(user: User) {
        let userName = user.name ?? "NONAME"
        let initials = userName.uppercased().prefix(2).uppercased()
        self.labelInitials.text = String(initials)
        let birthDate = user.birthDate ?? ""
        self.labelName.text = userName
        self.labelBirthDate.text = birthDate
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
