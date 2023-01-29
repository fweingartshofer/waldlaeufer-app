//
//  MetaInfoView.swift
//  waldlaeufer
//
//  Created by Florian Weingartshofer on 28.01.23.
//

import SwiftUI

struct MetaInfoView: View {
    var db: Float?
    @Binding var stressLevel: Double?
    
    
    var body: some View {
        if containsAnyData() {
            NavigationView {
                List {
                    if let db = db {
                        DetailRowView(label: "Decibel (dB)", content: String(format: "%.2f", db))
                    }
                    
                    if let stressLevel = stressLevel {
                        HStack {
                            DetailRowView(label: "Stress Level", content: "\(stressLevel * 100)%")
                            Spacer()
                            WarningLevelView(warningLevel: .constant(stressLevel))
                        }

                    } else {
                            DetailRowView(label: "Stress Level", content: "No Stress Level Available")
                    }
                }
            }
        }
    }
    
    private func containsAnyData() -> Bool {
        stressLevel != nil || db != nil
    }
}

struct MetaInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MetaInfoView(db: 40.5, stressLevel: .constant(1.0))
    }
}
