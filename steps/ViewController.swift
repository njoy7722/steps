//
//  ViewController.swift
//  steps
//
//  Created by Parag Pardeshi on 7/9/20.
//  Copyright © 2020 Parag Pardeshi. All rights reserved.
//

import UIKit
import HealthKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var healthStore = HKHealthStore()
    var steps = Steps()
    var stepsArray = [Int]()
    var toggle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Access Steps Count
        let healthKitTypes: Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!]
        
        // Check for Authentication
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
            if (bool) {
                // Authorization Successful
                self.steps.getStepsData { (result) in
                    DispatchQueue.main.async {
                        self.stepsArray = result.reversed()
                        self.stepsArray.removeLast()
                        self.tableView.reloadData()
                    }
                }
            } // end if
        } // end of checking authorization
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell") as? StepCell {

            // modify date
            var interval = DateComponents()
            // toggle date in chronological order
            interval.day = toggle ? (-stepsArray.count + 1 + indexPath.row) : -indexPath.row
            let now = Date()
            let cellDate = Calendar.current.date(byAdding: interval, to: now)

            cell.configureCell(date: cellDate!, step: stepsArray[indexPath.row])
            return cell
        } else {
            return StepCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepsArray.count
    }
    
    @IBAction func toggleButton(_ sender: Any) {
        toggle.toggle()
        stepsArray =  stepsArray.reversed()
        tableView.reloadData()
    }
    
}

