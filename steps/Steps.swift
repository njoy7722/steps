//
//  Steps.swift
//  steps
//
//  Created by Parag Pardeshi on 7/10/20.
//  Copyright © 2020 Parag Pardeshi. All rights reserved.
//

import Foundation
import HealthKit

class Steps {
    var healthStore = HKHealthStore()
    
    // get user steps for last 14 days
    func getStepsData(completion: @escaping ([Int]) -> Void) {
        
        var stepData = [Int]()
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Date().addingTimeInterval(-3600 * 24 * 7 * 2) // seconds for 14 days
        let endDate = Date()

        let predicate = HKQuery.predicateForSamples(
          withStart: startDate,
          end: endDate,
          options: [.strictStartDate, .strictEndDate]
        )

        // interval is 1 day
        var interval = DateComponents()
        interval.day = 1
        
        //
        let now = Date()
        let anchorDate = Calendar.current.startOfDay(for: now)

        let query = HKStatisticsCollectionQuery(
          quantityType: type,
          quantitySamplePredicate: predicate,
          options: .cumulativeSum,
          anchorDate: anchorDate,
          intervalComponents: interval
        )

        // get users steps count and return the value
        query.initialResultsHandler = { query, results, error in
          guard let results = results else {
            return
          }
    
          results.enumerateStatistics(
            from: startDate,
            to: endDate,
            with: { (result, stop) in
              let totalStepForADay = result.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                stepData.append(Int(totalStepForADay))
            }
          )
            DispatchQueue.main.async {
                completion(stepData)
            }
        }

        healthStore.execute(query)
    }
}
