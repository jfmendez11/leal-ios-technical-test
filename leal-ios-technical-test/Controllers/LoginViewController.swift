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
    
    //MARK: Outlets
    @IBOutlet weak var iOSTechTestLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var usersPicerView: UIPickerView!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Initial Setup
        overrideUserInterfaceStyle = .dark
        
        stackView.isHidden = true
        userDataManager.delegate = self
        usersPicerView.delegate = self
        
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
            UIView.transition(with: self.stackView,
                              duration: 0.5,
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
            return ""
        } else {
            return users[row-1].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            return
        } else {
            let selectedUser = users[row-1]
            UserDefaults.standard.set(selectedUser.id, forKey: K.UserDefaultsKeys.selectedUser)
            performSegue(withIdentifier: K.loginToTransactions, sender: self)
        }
    }
}
