//
//  TransacitonsViewController.swift
//  leal-ios-technical-test
//
//  Created by Juan Felipe Méndez on 7/07/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit
import RealmSwift

class TransacitonsViewController: UITableViewController {
    
    //MARK: Properties
    /// Regarding the transactions
    var transactionsDataManager = DataManager<[Transaction]>()
    //var transactions: [Transaction] = []
    
    // Realm
    var localTransactions: Results<RealmTransaction>?
    let realm = try! Realm()
    
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
        
        loadTransactions()

        if localTransactions?.count == 0 {
            transactionsDataManager.fetchData(from: "transactions")
        } else {
            tableView.reloadData()
            activityIndicator.stopAnimating()
        }
        
        /// Fetch the user's transactions if there's a selected user - if not, fetch all the transactions
        //        if let userId = selectedUser?.id {
        //            // GET: /users/{userId}/transactions
        //            transactionsDataManager.fetchData(from: "users/\(userId)/transactions")
        //        } else {
        //            // GET: /transactions
        //            transactionsDataManager.fetchData(from: "transactions")
        //        }
        
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
        navigationItem.rightBarButtonItem?.isEnabled = false
        let transactions = realm.objects(RealmTransaction.self)
            transactions.forEach { transaction in
                do {
                    try realm.write {
                        transaction.deleted = false
                        transaction.read = false
                    }
                } catch {
                    print("error reloading \(error)")
                }
            }
            activityIndicator.stopAnimating()
            tableView.showContentAnimation {
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
            }
//        if let userId = selectedUser?.id {
//            // GET: /users/{userId}/transactions
//            transactionsDataManager.fetchData(from: "users/\(userId)/transactions")
//        } else {
//            transactionsDataManager.fetchData(from: "transactions")
//        }
    }
    
    @objc private func sideBarMenuPressed() {
        performSegue(withIdentifier: K.goToSidebar, sender: self)
    }
    
    //MARK: - Realm methods
    func loadTransactions() {
        tableView.separatorStyle = .singleLine
        var predicate = "deleted == false"
        if realm.objects(RealmTransaction.self).filter("deleted == true OR read == true").first != nil {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        if let userId = selectedUser?.id {
            predicate += " && userId == \(userId)"
        }
        localTransactions = realm.objects(RealmTransaction.self).filter(predicate)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = localTransactions?.count ?? 0
        return count > 0 ? count + 1 : 0
    }
    
    /// Setup cells info to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let transactions = localTransactions {
        if indexPath.row < transactions.count {
            let transaction = transactions[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.transactionCell, for: indexPath) as! TransactionCell
            
            cell.isHidden = transaction.deleted
            
            cell.readImage.tintColor = transaction.read ? K.ColorPelette.grey : K.ColorPelette.brandYellow
            cell.commerceNameLabel.text = transaction.commerce.name
            cell.commerceBranchNameLabel.text = transaction.branch.name
            cell.createdDateLabel.text = transaction.createdDate.formatDateFromSelf(to: K.DateFormats.fullMonthWithRegularDayAndYear)
            if let unwrappedUsers = users, let user = unwrappedUsers[transaction.userId] {
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
        return UITableViewCell()
    }
    
    
    // MARK: - Table view delegate
    /// Return the height deppending of the selected user and the delete button
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = localTransactions?.count ?? 0
        if indexPath.row < count {
            return selectedUser != nil ? K.transactionCellHeightSingleUser : K.transactionCellHeightAllUsers
        } else {
            return K.deleteAllCellHeight
        }
    }
    
    /// Perform segue if a user clicks a transaction or delete everyting if he clicks on delete cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let transactions = localTransactions {
            let count = transactions.count
        if indexPath.row < count {
            
            navigationItem.rightBarButtonItem?.isEnabled = true
            do {
                try realm.write {
                    transactions[indexPath.row].read = true
                }
            } catch {
                print("Error saving read status, \(error)")
            }
            
            performSegue(withIdentifier: K.toTransactionInfo, sender: self)
            
        } else {
//            transactions = []
            navigationItem.rightBarButtonItem?.isEnabled = true
            transactions.forEach { transaction in
                do {
                    try realm.write {
                        transaction.deleted = true
                    }
                } catch {
                    print("Error saving read status, \(error)")
                }
            }
            
            tableView.showContentAnimation {
                self.tableView.separatorStyle = .none
                self.tableView.reloadData()
            }
        }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Make editable only the transaction cells
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let count = localTransactions?.count ?? 0
        if indexPath.row < count {
            return true
        } else {
            return false
        }
    }
    
    /// Delete action for a single transaction
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            navigationItem.rightBarButtonItem?.isEnabled = true
            
            if let transaction = localTransactions?[indexPath.row] {
                do {
                    try realm.write {
                        transaction.deleted = true
                    }
                } catch {
                    print("Error saving read status, \(error)")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    /// Set the user in the destination view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.toTransactionInfo {
            let destinationVC = segue.destination as! TransactionInfoViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                if let transaction = localTransactions?[indexPath.row] {
                destinationVC.transaction = transaction
                
                if let user = selectedUser {
                    destinationVC.user = user
                }
                else if let user = users?[transaction.userId] {
                    destinationVC.user = user
                }
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
        
        DispatchQueue.main.async {
            if let transactionsArray = model as? [Transaction] {
                //            transactions = transactionsArray
                transactionsArray.forEach {
                    
                    let newTransaction = RealmTransaction()
                    newTransaction.id = $0.id
                    newTransaction.userId = $0.userId
                    newTransaction.createdDate = $0.createdDate
                    
                    if let commerce = self.realm.objects(RealmCommerce.self).filter("id = \($0.commerce.id)").first {
                        newTransaction.commerce = commerce
                    } else {
                    let newCommerce = RealmCommerce()
                    newCommerce.id = $0.commerce.id
                    newCommerce.name = $0.commerce.name
                        newTransaction.commerce = newCommerce
                    }
                    
                    if let branch = self.realm.objects(RealmBranch.self).filter("id = \($0.branch.id)").first {
                        newTransaction.branch = branch
                    } else {
                        let newBranch = RealmBranch()
                    newBranch.id = $0.branch.id
                    newBranch.name = $0.branch.name
                    
                    newTransaction.branch = newBranch
                    }
                    
                    do {
                        try self.realm.write {
                            self.realm.add(newTransaction)
                        }
                    } catch {
                        print("Error saving transaction \(error)")
                    }
                }
            }
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

//MARK: - Extension to handle locla storage
extension DataManager {
    //MARK: - Local Storage
    /// Saving to the sandbox
    func save(transactions: [Transaction], to filepath: URL) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(transactions)
            try data.write(to: filepath)
        } catch {
            delegate?.didFailWithError(error)
        }
    }
    
    /// Loading from the sandbox
    func load(from filepath: URL) -> [Transaction]? {
        if let data = try? Data(contentsOf: filepath) {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode([Transaction].self, from: data)
            } catch {
                delegate?.didFailWithError(error)
            }
        }
        return nil
    }
}
