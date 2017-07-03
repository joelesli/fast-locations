//
//  Appearance.swift
//  FastLocation
//
//  Created by Joel Martinez on 4/24/17.
//  Copyright © 2017 JoelEsli.com. All rights reserved.
//

import UIKit

open class Appearance: NSObject {

    /// Sets the accent color defined in the UIColor extention 
    /// as the tintColor of the TabBar, NavigationBar, NavigationBar Text Attributes (Title),
    /// and the tint color of the TableViewCell.
    public class func setAppearance() {
            UITabBar.appearance().tintColor = UIColor.accentColor()
            UINavigationBar.appearance().tintColor = UIColor.accentColor()
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.accentColor()]
            UITableViewCell.appearance().tintColor = UIColor.accentColor()
            
    }
    
}
