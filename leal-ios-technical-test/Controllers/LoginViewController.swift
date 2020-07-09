//
//  ViewController.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 7/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Properties
    var userDataManager = DataManager<[User]>()
    var users: [User] = []
    var selectedUser: User?
    
    //MARK: Outlets
    @IBOutlet weak var iOSTechTestLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var usersPicerView: UIPickerView!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Initial Setup
        overrideUserInterfaceStyle = .dark
        
        stackView.isHidden = true
        userDataManager.delegate = self
        usersPicerView.delegate = self
        
        selectButton.titleLabel?.numberOfLines = 0
        selectButton.layer.cornerRadius = selectButton.frame.size.height * K.Multipliers.cornerRadiusToCircle
        
        /// Login animation
        iOSTechTestLabel.text = ""
        let labelText = K.loginLabelText
        var charIndex = 0.0
        for letter in labelText {
            Timer.scheduledTimer(withTimeInterval: 0.1*charIndex, repeats: false) { (timer) in
                self.iOSTechTestLabel.text?.append(letter)
            }
            charIndex += 1
        }
        /// Fetch users from API
        // GET: /users
        userDataManager.fetchData(from: "users")
    }
    
    //MARK: Actions
    /// Perform the segue when the user clicks the button
    @IBAction func selectedUserPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.loginToTransactions, sender: self)
    }
    
    
    //MARK: - Naviagtion
    /// Set the selected user or a dictionary of users if all the users are selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TransacitonsViewController
        if let user = selectedUser {
            destinationVC.selectedUser = user
        } else {
            destinationVC.users = users.toDictionary{ $0.id }
        }
    }
}

//MARK: - DataDelegate Extension
extension LoginViewController: DataDelegate {
    
    /// Delegate method to handle data changes from API requests
    func didUpdateData(model: Codable) {
        if let usersArray = model as? [User] {
            users = usersArray
        }
        DispatchQueue.main.async {
            self.usersPicerView.reloadAllComponents()
            self.selectButton.setTitle("Todos los usuarios", for: .normal)
            UIView.transition(with: self.stackView,
                              duration: K.animationDuration,
                              options: .showHideTransitionViews,
                              animations: {
                                self.stackView.isHidden = false
                              },
                              completion: nil
            )
        }
    }
    
    /// Delegate method to handle API fetching errors
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

//MARK: - UIPickerViewDataSource
extension LoginViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return K.numberOfLoginPickerViewComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return users.count + 1
    }
}

//MARK: - UIPickerViewDelegate
extension LoginViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Todos los usuarios"
        } else {
            return users[row-1].name
        }
    }
    
    /// Change the button's title depending on the picker's selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 0 {
            selectedUser = users[row-1]
            selectButton.setTitle(selectedUser!.name, for: .normal)
        } else {
            selectButton.setTitle("Todos los usuarios", for: .normal)
            selectedUser = nil
        }
    }
}
