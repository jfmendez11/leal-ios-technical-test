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
    /// Regarding the transactions
    var transactionsDataManager = DataManager<[Transaction]>()
    var transactions: [Transaction] = []
    
    /// Regarding the users
    var users: [Int:User]?
    var selectedUser: User?
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Initial  setup
        overrideUserInterfaceStyle = .light
        tableView.separatorStyle = .none
        
        transactionsDataManager.delegate = self
        
        activityIndicator.style = .large
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        /// NavBar setup
        navigationItem.hidesBackButton = true
        let menuImage = UIImage(systemName: K.menuIcon)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(sideBarMenuPressed))
        title = "Transacciones de \(selectedUser?.name ?? "todos los usuarios")"
        navigationController?.navigationBar.setupNavigationMultilineTitle(with: "Transacciones de \(selectedUser?.name ?? "todos los usuarios")")
        
        /// Fetch the user's transactions if there's a selected user - if not, fetch all the transactions
        if let userId = selectedUser?.id {
            // GET: /users/{userId}/transactions
            transactionsDataManager.fetchData(from: "users/\(userId)/transactions")
        } else {
            // GET: /transactions
            transactionsDataManager.fetchData(from: "transactions")
        }
        
        /// Register custom cells
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.transactionCell)
    }
    
    /// Reload the table view info when a transaction is read
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: Actions
    /// Fetch the users data again
    @IBAction func reloadPressed(_ sender: UIBarButtonItem) {
        // FIXME: Cache rollback to network
        activityIndicator.startAnimating()
        if let userId = selectedUser?.id {
            // GET: /users/{userId}/transactions
            transactionsDataManager.fetchData(from: "users/\(userId)/transactions")
        } else {
            transactionsDataManager.fetchData(from: "transactions")
        }
    }
    
    @objc private func sideBarMenuPressed() {
        performSegue(withIdentifier: K.goToSidebar, sender: self)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count > 0 ? transactions.count + 1 : 0
    }
    
    /// Setup cells info to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < transactions.count {
            let transaciton = transactions[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.transactionCell, for: indexPath) as! TransactionCell
            
            cell.readImage.tintColor = transaciton.read ? K.ColorPelette.grey : K.ColorPelette.brandYellow
            cell.commerceNameLabel.text = transaciton.commerce.name
            cell.commerceBranchNameLabel.text = transaciton.branch.name
            cell.createdDateLabel.text = transaciton.createdDate.formatDateFromSelf(to: K.DateFormats.fullMonthWithRegularDayAndYear)
            if let unwrappedUsers = users, let user = unwrappedUsers[transaciton.userId] {
                cell.userNameLabel.text = user.name
            }
            cell.userNameLabel.isHidden = selectedUser != nil
            
            
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = .red
            cell.textLabel?.text = "Borrar Todas"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .white
            cell.accessoryView = UIImageView(image: UIImage(systemName: K.trashIcon), highlightedImage: nil)
            cell.accessoryView?.tintColor = .white
            return cell
        }
    }
    
    
    // MARK: - Table view delegate
    /// Return the height deppending of the selected user and the delete button
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < transactions.count {
            return selectedUser != nil ? K.transactionCellHeightSingleUser : K.transactionCellHeightAllUsers
        } else {
            return K.deleteAllCellHeight
        }
    }
    
    /// Perform segue if a user clicks a transaction or delete everyting if he clicks on delete cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < transactions.count {
            transactions[indexPath.row].read = true
            performSegue(withIdentifier: K.toTransactionInfo, sender: self)
        } else {
            tableView.showContentAnimation {
                self.tableView.separatorStyle = .none
                self.transactions = []
                self.tableView.reloadData()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Make editable only the transaction cells
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < transactions.count {
            return true
        } else {
            return false
        }
    }
    
    /// Delete action for a single transaction
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            transactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    /// Set the user in the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.toTransactionInfo {
            let destinationVC = segue.destination as! TransactionInfoViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let transaction = transactions[indexPath.row]
                destinationVC.transaction = transaction
                if let user = selectedUser {
                    destinationVC.user = user
                }
                else if let user = users?[transaction.userId] {
                    destinationVC.user = user
                }
            }
        } else if segue.identifier == K.goToSidebar {
            let destinationVC = segue.destination as! SidebarViewController
            destinationVC.selectedUser = selectedUser
        }
    }
}

//MARK: - Extensions

//MARK: DataDelegate
extension TransacitonsViewController: DataDelegate {
    
    /// Delegate method to handle data changes from API requests
    func didUpdateData(model: Codable) {
        if let transactionsArray = model as? [Transaction] {
            transactions = transactionsArray
        }
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.showContentAnimation {
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
            }
        }
    }
    
    /// Delegate method to handle API fetching errors
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
