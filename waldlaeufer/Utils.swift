//
//  Utils.swift
//  waldlaeufer
//
//  Created by Florian Weingartshofer on 28.01.23.
//

import Foundation

func mapDbAndStressLevelToWellbeing(db: Float?, stressLevel: Double?) -> SubjectiveWellbeing {
    var dbWeight: Float = 0
    var stressWeight: Float = 0
    var normalizedDb: Float = 0
    var normalizedStress: Float = 0
    
    if let db = db {
        normalizedDb = db / 160
        dbWeight = 0.5
    }
    if let stressLevel = stressLevel {
        normalizedStress = Float(stressLevel)
        stressWeight = 1 - dbWeight
    } else {
        dbWeight = 1
    }
    
    let combinedMetric: Float = dbWeight * normalizedDb + stressWeight * normalizedStress

    let binIntervals: [Float] = [0.125, 0.25, 0.5, 0.75, 0.875]
    for (index, interval) in binIntervals.enumerated() {
        if combinedMetric <= interval {
            return SubjectiveWellbeing(rawValue: index)!
        }
    }
    return SubjectiveWellbeing.GOOD
}
