//
//  TabBarViewController.swift
//  FastLocation
//
//  Created by Joel Martinez on 5/9/17.
//  Copyright © 2017 JoelEsli.com. All rights reserved.
//

import UIKit
import MapKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //if this is a phone, the map navigation flow changes
        //such that the map, and not a list, is shown.
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            if let controllers = viewControllers {
                //go directly to the map
                let mapController = MapViewController.controller()
                mapController.data = SampleData.data() as? [MKAnnotation]
                let navController = UINavigationController(rootViewController: mapController)
                navController.tabBarItem = controllers[3].tabBarItem
                navController.navigationBar.isTranslucent = false 
                var contr = controllers
                contr[3] = navController
                self.setViewControllers(contr, animated: false)
            }
        }
        
        //select the around me tab
        selectedIndex = 2

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//        
//        
//    }
    

 

}
