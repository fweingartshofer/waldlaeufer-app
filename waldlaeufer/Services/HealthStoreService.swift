//
// Created by Florian Weingartshofer on 28.01.23.
//

import Foundation
import HealthKit

final class HealthStoreService {
    private let healthStore: HKHealthStore = HKHealthStore()
    
    public var hasStress: Bool {
        getStressLevelData().count > 0
    }

    init() {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
    }

    func getStressLevelData() -> [Double] {
        authorize()
        let stressType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        let stressSort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let fiveMinutesAgo = Date(timeIntervalSinceNow: -5 * 60)
        let predicate = HKQuery.predicateForSamples(withStart: fiveMinutesAgo, end: Date(), options: .strictEndDate)
        var stressLevels: [Double] = []
        let stressSampleQuery = HKSampleQuery(sampleType: stressType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [stressSort]) { (query, samples, error) in
            guard let samples = samples else {
                print("Error fetching samples: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            stressLevels = samples.map { sample in
                let stressSample = sample as! HKQuantitySample
                return stressSample.quantity.doubleValue(for: HKUnit(from: "ms"))
            }
        }
        healthStore.execute(stressSampleQuery)
        return stressLevels
    }
    
    func averageStressLevel() -> Double {
        let data = getStressLevelData()
        return data.reduce(0, +) / Double(data.count)
    }
    
    func authorize() {
        if let stressLevelType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) {
            let readDataTypes: Set<HKQuantityType> = [stressLevelType]
            healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { (success, error) in
                if let error = error {
                    print("Error requesting authorization: \(error.localizedDescription)")
                } else {
                    print("Successfully requested authorization for stress level data")
                }
            }
        }
    }

}
