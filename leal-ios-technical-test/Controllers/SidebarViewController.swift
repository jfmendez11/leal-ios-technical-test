//
//  SidebarViewController.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 9/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class SidebarViewController: UIViewController {
    
    var selectedUser: User?
    var sidebarItems = ["Cambiar de usuario"]
    var sidebarIcons = [K.logoutIcon]
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var selectedUserNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        if let user = selectedUser {
            DispatchQueue.global().async {
                if let url = URL(string: user.photo) {
                    let urlContets = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.profileImage.generateCirledImage(from: urlContets)
                        self.selectedUserNameLabel.text = user.name
                        self.selectedUserNameLabel.textColor = K.ColorPelette.brandYellow
                    }
                }
            }
        } else {
            profileImage.image = UIImage(systemName: K.allUsersProfileImage)
            profileImage.tintColor = K.ColorPelette.brandYellow
            selectedUserNameLabel.text = "Todos los usuarios"
            selectedUserNameLabel.textColor = K.ColorPelette.brandYellow
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - TableView Data Source Extenseion
extension SidebarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sidebarItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.sidebarItemCell, for: indexPath)
        
        let icon = sidebarIcons[indexPath.row], text = sidebarItems[indexPath.row]
//        cell.imageView?.image = UIImage(systemName: icon)
//        cell.imageView?.tintColor = .white
//        cell.textLabel?.text = text
        let imageView = cell.subviews[0].subviews[0].subviews[0] as! UIImageView
        imageView.image = UIImage(systemName: icon)
        let textLabel = cell.subviews[0].subviews[0].subviews[1] as! UILabel
        textLabel.text = text
        
        return cell
    }
    
    
}

//MARK: - TableView Delegate Extenseion
extension SidebarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return K.sidebarItemCellHeight
    }
}
