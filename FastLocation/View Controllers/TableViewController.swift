//
//  TableViewController.swift
//  FastLocation
//
//  Created by Joel Martinez on 4/24/17.
//  Copyright © 2017 JoelEsli.com. All rights reserved.
//

import UIKit
import MapKit

/// TableDataItem is a protocol that your model object must implement
/// so that you can use the TableViewControler, or any of it's subclasses
/// by simply passing your model objects to the data variable.
public protocol TableDataItem {
    
    /// String used in the textLabel of a UITableViewCell.
    var title : String? { get }
    /// String used in the detailText of a UITableViewCell.
    var subtitle : String? { get }
    /// Image assigned to the imageView of a UITableViewCell.
    var cellImage : UIImage? { get set }
    
    /// Lets you override the tint color of the cell.imageView,
    /// which is by default set to the UIColor.accentColor()
    var cellImageTintColor : UIColor? { get }
    
    /// True if data item has been marked as a favorite.
    var isFavorite : Bool { get set}
    
    
    /// The date when the data item was last used, nil otherwise.
    var lastUsed : Date? { get set}
}

public protocol DetailViewController {
    var tableDataItem : TableDataItem? {set get}
    var canTrackLastUsed : Bool? { set get }
    var canManageFavorite : Bool? { set get }
}

/// Table view controller that can display TableDataItems.
/// By default it has one section and the number of rows is 
/// equal to the number of items in the `var data`.
///
/// To provide a device appropriate view flow, TableViewController uses the following method to manage iPad and iPhone specific navigation.
///
/// `prepare(for segue: UIStoryboardSegue, sender: Any?)` handles showDetail segues that are intended for the iPad by calling `prepareIPad(for segue: UIStoryboardSegue, sender: Any?)`.
///
///
/// `shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool` returns true when `UIDevice.current.userInterfaceIdiom == .pad`.
///  If `UIDevice.current.userInterfaceIdiom == .phone` it calls `prepareIPhone(withIdentifier identifier: String, sender: Any?)` before returning false.
open class TableViewController: UITableViewController {

    var dataItemMgr = SampleDataObjects.shared
    
    /// The data source of the TableViewController.
    public var data = [TableDataItem]()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    fileprivate func selectedCell(_ tableView: UITableView) -> UITableViewCell? {
        var sender : UITableViewCell?
        if let indexPath = tableView.indexPathForSelectedRow {
            sender = tableView.cellForRow(at: indexPath)
        }
        return sender
    }
    
    fileprivate func idiomDependentSegue(withSegue identifier: String) {
         if UIDevice.current.userInterfaceIdiom == .pad {
            performSegue(withIdentifier: identifier, sender: selectedCell(tableView))
        }
        else if UIDevice.current.userInterfaceIdiom == .phone {
            //do nothing
        }
    }
    
    open func refreshData() {
        data = dataItemMgr.data
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let dataItem = data[indexPath.row]
        cell.textLabel?.text = dataItem.title ?? ""
        cell.detailTextLabel?.text = dataItem.subtitle ?? ""
        cell.imageView?.image = dataItem.cellImage
        cell.imageView?.tintColor = dataItem.cellImageTintColor
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    // MARK: - Editing
    func beginEditing() {
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditing)),
                                         animated: true)
        tableView.setEditing(true, animated: true)
    }
    
    func endEditing() {
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(beginEditing)),
                                         animated: true)
        tableView.setEditing(false, animated: true)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        prepareIPad(for: segue, sender: sender)
        
    }
    
    override open func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        
        let idiom = UIDevice.current.userInterfaceIdiom
        
        //On iPad yes.
        if idiom == .pad {
            return true
        }
        //On iPhone no.
        //But I wan to push a specific controller into the current navigation controller
        else if idiom == .phone {
            prepareIPhone(withIdentifier: identifier, sender: sender)
        }
        
        return false
    }
    
    /// Prepares showDetail segues that are inteded for iPad devices. It is called from `prepare(for segue: UIStoryboardSegue, sender: Any?)`
    ///
    /// - Parameters:
    ///   - segue: The segue passed in `prepare(for segue: UIStoryboardSegue, sender: Any?)`
    ///   - sender: The sender passed in `prepare(for segue: UIStoryboardSegue, sender: Any?)`
    open func prepareIPad(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            return
        }
        
        if let name = SegueName(rawValue: segue.identifier ?? "") {
            switch name {
            case .favorite, .recent, .aroundMe:
                if let controller = (segue.destination as? UINavigationController)?.viewControllers.first as? LabelViewController,
                    let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell) {
                    
                    controller.tableDataItem = data[indexPath.row]
                    controller.canTrackLastUsed = name != .recent
                    
                }
                
                
            case .map :
                if let controller = (segue.destination as? UINavigationController)?.viewControllers.first as? MapViewController {
                    
                    controller.data = data as? [MKAnnotation]
                    
                    if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let mdi = data[indexPath.row] as? MKAnnotation {
                        controller.selectedMapDataItem = mdi
                    }
                    
                    
                }
                
            case .more : break
                
            }
        }
    }
    
    
    /// Intercepts showDetail segues that work well for iPad and pushes the  DetailViewController in the table view controller's navigation controller.
    /// This method is called from `shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool` when the user device idiom is `.phone`.
    ///
    /// - Parameters:
    ///   - identifier: The identifier passed to `shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool`.
    ///   - sender: The sender passed to `shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool`.
    open func prepareIPhone(withIdentifier identifier: String, sender: Any?) {
        
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return
        }
        
        if let name = SegueName(rawValue: identifier) {
            switch name {
            case .favorite, .recent, .aroundMe:
                
                let controller = LabelViewController.controller()
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell) {
                    
                    controller.tableDataItem = data[indexPath.row]
                    controller.canTrackLastUsed = name != .recent
                }
                navigationController?.pushViewController(controller, animated: true)
                
            case .map :
                let controller = MapViewController.controller()
                controller.data = data as? [MKAnnotation]
                
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let mdi = data[indexPath.row] as? MKAnnotation {
                    controller.selectedMapDataItem = mdi
                }
                navigationController?.pushViewController(controller, animated: true)
                
            case .more : break
                
            }
        }
    }
    
}


/// Table view controller that lists TableDataItems where `isFavorite` is set to true. 
class FavoritesTableViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        endEditing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        idiomDependentSegue(withSegue: SegueName.favorite.rawValue)
        
    }
    
    override func refreshData() {
        data = dataItemMgr.sortedFavorites
        tableView.reloadData()
    }
    
    
//     // Override to support conditional editing of the table view.
//     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//     // Return false if you do not want the specified item to be editable.
//     return true
//     }
    
    
    //MARK: - Editing
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dataItemMgr.toggleFavorite(data[indexPath.row])
            data.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        dataItemMgr.move(favorite: fromIndexPath.row, to: to.row)
    }
    
    
    
}

class RecentsTableViewController: TableViewController {
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recents"
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        idiomDependentSegue(withSegue: SegueName.recent.rawValue)
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let dataItem = data[indexPath.row]
        
        cell.detailTextLabel?.text = dateFormatter.string(from: dataItem.lastUsed ?? Date())
        
        return cell
    }
    
    override func refreshData() {
        data = dataItemMgr.data.filter() { $0.lastUsed != nil }.sorted(by: { (item01, item02) -> Bool in
            return (item01.lastUsed?.timeIntervalSinceReferenceDate ?? 0) >= (item02.lastUsed?.timeIntervalSinceReferenceDate ?? 0)
        })
        
        tableView.reloadData()
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            data[indexPath.row].lastUsed = nil
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}

class AroundMeTableViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Around Me"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        idiomDependentSegue(withSegue: SegueName.aroundMe.rawValue)
    }
}

class MapTableViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        idiomDependentSegue(withSegue: SegueName.map.rawValue)    }
    
}

class MoreTableViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "More"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        idiomDependentSegue(withSegue: SegueName.map.rawValue)    }
    
}



