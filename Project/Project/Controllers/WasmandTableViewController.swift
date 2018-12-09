//
//  WasmandTableViewController.swift
//  Project
//
//  Created by Matthias Warnez on 15/11/2018.
//  Copyright © 2018 Matthias Warnez. All rights reserved.
//

import UIKit
import LocalAuthentication


class WasmandTableViewController: UITableViewController {
    
    var wasmanden: [Wasmand] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        if let wasmanden = Wasmand.loadFromFile(){
            self.wasmanden = wasmanden
        }
        
        self.tableView.rowHeight = 80
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return wasmanden.count
        }  else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //decue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "WasmandCell", for: indexPath) as! WasmandTableViewCell
        
        // Fetch model object tot display
        let wasmand = wasmanden[indexPath.row]
        
        // Configure cell
        cell.update(with: wasmand)
        cell.showsReorderControl = true
        
        //return cell
        return cell
    }
    
    
    @IBAction func editButtonTapped(_sender: UIBarButtonItem){
        
        let tableVieweditingMode = tableView.isEditing
        tableView.setEditing(!tableVieweditingMode, animated: true)
    }
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "EditWasmand" {
            let indexPath = tableView.indexPathForSelectedRow!
            let wasmand = wasmanden[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let addEditWasmandTableViewController = navController.topViewController as! AddEditWasmandTableViewController
            addEditWasmandTableViewController.wasmand = wasmand
        }
    }
    
    
    
    
    @IBAction func unwindToWasmandTableView(segue: UIStoryboardSegue)
    {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as!AddEditWasmandTableViewController
        if let wasmand = sourceViewController.wasmand {
            if let selectedIndexPath =
                tableView.indexPathForSelectedRow {
                wasmanden[selectedIndexPath.row] = wasmand
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: wasmanden.count,section: 0)
                wasmanden.append(wasmand)
                tableView.insertRows(at: [newIndexPath],with: .automatic)
            }
        }
        
        Wasmand.saveToFile(wasmanden: wasmanden)
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedWasmand = wasmanden.remove(at: fromIndexPath.row)
        wasmanden.insert(movedWasmand, at: to.row)
        tableView.reloadData()
    }
    
    // icon voor verwijderen
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Bevestig om te verwijderen"
        
        var authError: NSError?
        
        // controle of fingerprint is beschikbaar voor aios versie.
        if #available(iOS 8.0, macOS 10.12.1, *) {
            // 2. Check if the device has a fingerprint sensor
            if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    DispatchQueue.main.async {
                        if success {
                            if editingStyle == .delete{
                                self.wasmanden.remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexPath], with: . automatic)
                                Wasmand.saveToFile(wasmanden: self.wasmanden)
                            }
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            let alert = UIAlertController(title: "Geen succesvolle aanmelding", message: "Het is niet mogelijk om het element uit de lijst te verwijderen.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
            } else {
                if editingStyle == .delete{
                    self.wasmanden.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: . automatic)
                    Wasmand.saveToFile(wasmanden: self.wasmanden)
                }
            }
        } else {
            if editingStyle == .delete{
                self.wasmanden.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: . automatic)
                Wasmand.saveToFile(wasmanden: self.wasmanden)
            }
            
        }
        
    }
}
