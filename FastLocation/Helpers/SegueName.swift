//
//  SegueName.swift
//  FastLocation
//
//  Created by Joel Martinez on 4/24/17.
//  Copyright © 2017 JoelEsli.com. All rights reserved.
//

import UIKit

/// Names used for the showDetail segues in the
/// viewControllers of the TabBarViewController.
///
/// - favorite: Segue identifier of the segue from a cell in the FavoritesTableViewController to a detail view controller
/// - recent: Segue identifier of the segue from a cell in the RecentsTableViewController to a detail view controller
/// - aroundMe: Segue identifier of the segue from a cell in the AroundMeTableViewController to a detail view controller
/// - map: Segue identifier of the segue from a cell in the MapTableViewController to a detail view controller
/// - more: Segue identifier of the segue from a cell in the MoreTableViewController to a detail view controller. Note that this segue is not used in the Main storyboard.
public enum SegueName : String {
    case favorite = "showfavorite"
    case recent =   "showrecent"
    case aroundMe = "showaroundme"
    case map =      "showinmap"
    case more =     "showmore"
    
}
