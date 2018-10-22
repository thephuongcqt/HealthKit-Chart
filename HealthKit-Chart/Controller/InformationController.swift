//
//  InformationController.swift
//  HealthKit-Chart
//
//  Created by Nguyen The Phuong on 10/19/18.
//  Copyright © 2018 Nguyen The Phuong. All rights reserved.
//

import UIKit
import HealthKit

class InformationController: UITableViewController {
    
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblSex: UILabel!
    @IBOutlet weak var lblBlood: UILabel!
    @IBOutlet weak var lblTodayStep: UILabel!        
    @IBOutlet weak var lblEnergyBurn: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
    }
    
    func loadHealthData(){
        let userInfo = ProfileData.getUserProfile();
        lblAge.text = userInfo.age == nil ? "" : "\(userInfo.age!)"
        lblSex.text = userInfo.biologicalSex == nil ? "" : "\(userInfo.biologicalSex!.stringRepresentation)"
        lblBlood.text = userInfo.bloodType == nil ? "" : "\(userInfo.bloodType!.stringRepresentation)"
        
        let healthKitAssistant = HealthKitAssistant.shared
        healthKitAssistant.getTodaysSteps { (todaySteps) in
            DispatchQueue.main.async {
                self.lblTodayStep.text = "\(todaySteps)"
            }
        }
        healthKitAssistant.getActiveEnergy { (energyBurn) in
            DispatchQueue.main.async {
                self.lblEnergyBurn.text = "\(energyBurn)"
            }
        }
    }    
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        loadHealthData()
        refreshControl.endRefreshing()
    }

}
