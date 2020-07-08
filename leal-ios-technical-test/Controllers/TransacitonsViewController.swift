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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionsDataManager.delegate = self
        
        navigationItem.hidesBackButton = true
        let menuImage = UIImage(systemName: K.menuIcon)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: nil)
        
        if let userId = UserDefaults.standard.string(forKey: K.UserDefaultsKeys.selectedUser) {
            transactionsDataManager.fetchData(from: "users/\(userId)/transactions")
        }
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.transactionCell)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transactions.count
    }
    
    // MARK: - Table view delegate
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaciton = transactions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.transactionCell, for: indexPath) as! TransactionCell
        
        cell.readImage.tintColor = transaciton.read ? K.ColorPelette.grey : K.ColorPelette.brandYellow
        cell.commerceNameLabel.text = transaciton.commerce.name
        cell.commerceBranchNameLabel.text = transaciton.branch.name
        cell.createdDateLabel.text = transaciton.createdDate
        cell.userNameLabel.isHidden = true
        
        return cell
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return K.transactionCellHeightSingleUser
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
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
extension TransacitonsViewController: DataDelegate {
    
    /// Delegate method to handle data changes from API requests
    func didUpdateData(model: Codable) {
        if let transactionsArray = model as? [Transaction] {
            transactions = transactionsArray
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// Delegate method to handle API fetching errors
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
