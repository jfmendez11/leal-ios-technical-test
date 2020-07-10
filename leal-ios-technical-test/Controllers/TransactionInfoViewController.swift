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
    /// Regarding transacitions
    var transactionInfoDataManager = DataManager<TransactionInfo>()
    var transactionInfo: TransactionInfo?
    var transaction: RealmTransaction?
    
    /// Regarding the user
    var user: User?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    //MARK: Outlets
    /// Regarding the profile information
    @IBOutlet weak var profileView: CustomCardView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    
    /// Regarding the current transaction
    @IBOutlet weak var transactionInfoView: CustomCardView!
    @IBOutlet weak var commerceNameLabel: UILabel!
    @IBOutlet weak var branchNameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.style = .large
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        /// Initial setup
        overrideUserInterfaceStyle = .light
        
        transactionInfoDataManager.delegate = self
        
        profileView.isHidden = true
        transactionInfoView.isHidden = true
        
        /// Relevant fetches to complete the relevant content to display
        if let transactionId = transaction?.id {
            // GET: /transactions/{transactionId}/info
            transactionInfoDataManager.fetchData(from: "transactions/\(transactionId)/info")
        }
        if user != nil {
            setUpUserProfile()
        }
    }
    
    // MARK: Methods
    /// Populate the user's information
    private func setUpUserProfile() {
        DispatchQueue.global().async {
            if let url = URL(string: self.user!.photo) {
                let urlContets = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.profileImage.generateCirledImage(from: urlContets)
                    
                    self.userNameLabel.attributedText =
                        NSMutableAttributedString()
                            .bold("Nombre: ")
                            .normal(self.user!.name)
                    
                    self.birthdayLabel.attributedText =
                        NSMutableAttributedString()
                            .bold("Nacimiento: ")
                            .normal(self.user!.birthday.formatDateFromSelf(to: K.DateFormats.fullMonthWithRegularDayAndYear)!)
                    
                    self.joinedLabel.attributedText =
                        NSMutableAttributedString()
                        .bold("Leal desde: ")
                        .normal(self.user!.createdDate.formatDateFromSelf(to: K.DateFormats.fullMonthWithRegularDayAndYear)!)
                    
                    self.profileView.showContentAnimation {
                        self.profileView.isHidden = false
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}

//MARK: - DataDelegate Extension
extension TransactionInfoViewController: DataDelegate {
    
    /// Delegate method to handle data changes from API requests
    func didUpdateData(model: Codable) {
        /// Check if the data manager is fetchig the transaction info and setup the info
        if let transactionInformation = model as? TransactionInfo, let selectedTransaction = transaction {
            transactionInfo = transactionInformation
            DispatchQueue.main.async {
                self.commerceNameLabel.attributedText =
                    NSMutableAttributedString()
                        .bold("Comercio: ")
                        .normal(selectedTransaction.commerce.name)
                
                self.branchNameLabel.attributedText =
                    NSMutableAttributedString()
                        .bold("Local: ")
                        .normal(selectedTransaction.branch.name)
                
                self.createdDateLabel.attributedText =
                    NSMutableAttributedString()
                        .bold("Fecha: ")
                        .normal(selectedTransaction.createdDate.formatDateFromSelf(to: K.DateFormats.fullMonthWithRegularDayAndYear)!)
                
                self.valueLabel.attributedText =
                    NSMutableAttributedString()
                        .bold("Valor: ")
                        .normal(String(transactionInformation.value))
                
                self.pointsLabel.attributedText =
                    NSMutableAttributedString()
                        .bold("Puntos: ")
                        .normal(String(transactionInformation.points))
                
                self.transactionInfoView.showContentAnimation {
                    self.transactionInfoView.isHidden = false
                }
            }
        }
    }
    
    /// Delegate method to handle API fetching errors
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ups", message: "Ocurrió un error al cargar los datos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
