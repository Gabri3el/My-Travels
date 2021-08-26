//
//  TravelsTableViewController.swift
//  My Travels
//
//  Created by Gabriel on 25/08/21.
//

import UIKit

class TravelsTableViewController: UITableViewController {
    
    var myTravels: [Dictionary<String, String>] = []
    var controllerNavigation = "Add"

    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }

    override func viewDidAppear(_ animated: Bool) {
        controllerNavigation = "Add"
        ReloadData()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myTravels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let myListOfTravels = myTravels[indexPath.row]["Local"]

        cell.textLabel?.text = myListOfTravels
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete{
            StorageData().Remove(indice: indexPath.row)
            ReloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.controllerNavigation = "list"
        performSegue(withIdentifier: "ViewLocation", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewLocation"{
            let vcDestiny = segue.destination as! ViewController
            if self.controllerNavigation == "list"{
                if let indiceRecovery = sender{
                    let indice = indiceRecovery as! Int
                    vcDestiny.travel = myTravels[indice]
                    vcDestiny.indiceSelect = indice
                }
            }else{
                vcDestiny.travel = [:]
                vcDestiny.indiceSelect = -1
            }
        }
    }
    
    
    func ReloadData(){
        myTravels = StorageData().getData()
        tableView.reloadData()
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
