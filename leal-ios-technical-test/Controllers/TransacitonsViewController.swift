//
//  TransacitonsViewController.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 7/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class TransacitonsViewController: UITableViewController {
    
    //MARK: Properties
    var transactionsDataManager = DataManager<[Transaction]>()
    var transactions: [Transaction] = []
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.isHidden = true
        tableView.separatorStyle = .none
        
        transactionsDataManager.delegate = self
        
        navigationItem.hidesBackButton = true
        let menuImage = UIImage(systemName: K.menuIcon)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: nil)
        
        if let userId = UserDefaults.standard.string(forKey: K.UserDefaultsKeys.selectedUser) {
            transactionsDataManager.fetchData(from: "users/\(userId)/transactions")
        }
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.transactionCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: Actions
    @IBAction func reloadPressed(_ sender: UIBarButtonItem) {
        if let userId = UserDefaults.standard.string(forKey: K.UserDefaultsKeys.selectedUser) {
            transactionsDataManager.fetchData(from: "users/\(userId)/transactions")
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count > 0 ? transactions.count + 1 : 0
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < transactions.count {
            let transaciton = transactions[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.transactionCell, for: indexPath) as! TransactionCell
            
            cell.readImage.tintColor = transaciton.read ? K.ColorPelette.grey : K.ColorPelette.brandYellow
            cell.commerceNameLabel.text = transaciton.commerce.name
            cell.commerceBranchNameLabel.text = transaciton.branch.name
            cell.createdDateLabel.text = transaciton.createdDate.formatDateFromSelf(to: "MMMM dd, yyyy")
            cell.userNameLabel.isHidden = true
            
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = .red
            cell.textLabel?.text = "Borrar Todas"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .white
            cell.accessoryView = UIImageView(image: UIImage(systemName: "trash.fill"), highlightedImage: nil)
            cell.accessoryView?.tintColor = .white
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < transactions.count {
            return K.transactionCellHeightSingleUser
        } else {
            return 30.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < transactions.count {
            transactions[indexPath.row].read = true
            performSegue(withIdentifier: K.toTransactionInfo, sender: self)
        } else {
            UIView.transition(with: self.tableView,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.tableView.separatorStyle = .none
                                self.transactions = []
                                self.tableView.reloadData()
                              },
                              completion: nil
            )
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < transactions.count {
            return true
        } else {
            return false
        }
     }
    
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            transactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
     }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TransactionInfoViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.transaction = transactions[indexPath.row]
        }
    }
    
}

//MARK: - DataDelegate Extension
extension TransacitonsViewController: DataDelegate {
    
    /// Delegate method to handle data changes from API requests
    func didUpdateData(model: Codable) {
        if let transactionsArray = model as? [Transaction] {
            transactions = transactionsArray
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.tableView,
                              duration: 0.75,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.tableView.separatorStyle = .singleLine
                                self.tableView.reloadData()
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
