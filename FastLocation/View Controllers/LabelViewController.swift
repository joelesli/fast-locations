//
//  LabelViewController.swift
//  FastLocation
//
//  Created by Joel Martinez on 4/24/17.
//  Copyright © 2017 JoelEsli.com. All rights reserved.
//

import UIKit

open class LabelViewController: UIViewController, DetailViewController {

    @IBOutlet weak var label : UILabel!
    
    //MARK: - Detail View Controller
    public var tableDataItem : TableDataItem?
    public var canTrackLastUsed : Bool? = true
    public var canManageFavorite : Bool? = true
    
    
    class func controller() -> LabelViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LabelViewController") as! LabelViewController
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.text = tableDataItem?.title ?? "Select a city"
        
        configureFavoriteButton()
        
        if let canTLU = canTrackLastUsed, canTLU {
            tableDataItem?.lastUsed = Date()
        }
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureFavoriteButton() {
        
        if let canMF = canManageFavorite, canMF, let tdi = tableDataItem {
            let favoriteIcon = tdi.isFavorite ? "★" : "☆"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: favoriteIcon, style: UIBarButtonItemStyle.plain, target: self, action: #selector(toggle(favorite:)))
        }
        
        
    }
    
    func toggle(favorite button: UIButton) {
        SampleDataObjects.shared.toggleFavorite(tableDataItem)
        configureFavoriteButton()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
