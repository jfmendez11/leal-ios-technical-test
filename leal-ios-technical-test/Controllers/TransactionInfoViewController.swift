//
//  TransactionInfoViewController.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 8/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class TransactionInfoViewController: UIViewController {
    
    //MARK: Properties
    var transactionInfoDataManager = DataManager<TransactionInfo>()
    var transactionInfo: TransactionInfo?
    var transaction: Transaction?
    
    var userDataManager = DataManager<User>()
    var user: User?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    
    @IBOutlet weak var transactionInfoView: UIView!
    @IBOutlet weak var commerceNameLabel: UILabel!
    @IBOutlet weak var branchNameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionInfoDataManager.delegate = self
        userDataManager.delegate = self
        
        if let transactionId = transaction?.id {
            transactionInfoDataManager.fetchData(from: "transactions/\(transactionId)/info")
        }
        if let userId = transaction?.userId {
            userDataManager.fetchData(from: "users/\(userId)")
        }
        profileView.layer.cornerRadius = profileView.frame.size.height * 0.04
        profileView.layer.shadowColor = UIColor.black.cgColor
        profileView.layer.shadowOpacity = 0.5
        profileView.layer.shadowOffset = .zero
        profileView.layer.shadowRadius = 10
        profileView.layer.shadowPath = UIBezierPath(rect: profileView.bounds).cgPath
        
        transactionInfoView.layer.cornerRadius = profileView.frame.size.height * 0.04
        transactionInfoView.layer.shadowColor = UIColor.black.cgColor
        transactionInfoView.layer.shadowOpacity = 0.5
        transactionInfoView.layer.shadowOffset = .zero
        transactionInfoView.layer.shadowRadius = 10
        transactionInfoView.layer.shadowPath = UIBezierPath(rect: transactionInfoView.bounds).cgPath
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

//MARK: - DataDelegate Extension
extension TransactionInfoViewController: DataDelegate {
    
    /// Delegate method to handle data changes from API requests
    func didUpdateData(model: Codable) {
        if let transactionInformation = model as? TransactionInfo, let selectedTransaction = transaction {
            transactionInfo = transactionInformation
            DispatchQueue.main.async {
                self.commerceNameLabel.text = selectedTransaction.commerce.name
                self.branchNameLabel.text = selectedTransaction.branch.name
                self.createdDateLabel.text = selectedTransaction.createdDate.formatDateFromSelf(to: "MMMM dd, yyyy")
                self.valueLabel.text = String(transactionInformation.value)
                self.pointsLabel.text = String(transactionInformation.points)
            }
        } else if let selectedUser = model as? User {
            user = selectedUser
            DispatchQueue.global().async {
                if let url = URL(string: selectedUser.photo) {
                    let urlContets = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let imageData = urlContets {
                            self.profileImage.image = UIImage(data: imageData)
                            self.profileImage.layer.cornerRadius = self.profileImage.frame.height * 0.5
                            self.profileImage.contentMode = .scaleAspectFill
                            self.profileImage.clipsToBounds = true
                            self.profileImage.layer.borderColor = K.ColorPelette.brandYellow.cgColor
                            self.profileImage.layer.borderWidth = 4
                        }
                        self.userNameLabel.text = selectedUser.name
                        self.birthdayLabel.text = selectedUser.birthday.formatDateFromSelf(to: "MMMM dd, yyyy")
                        self.joinedLabel.text = selectedUser.createdDate.formatDateFromSelf(to: "MMMM dd, yyyy")
                    }
                }
                
            }
        }
    }
    
    /// Delegate method to handle API fetching errors
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
