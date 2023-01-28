//
//  WarningLevelView.swift
//  waldlaeufer
//
//  Created by Florian Weingartshofer on 28.01.23.
//

import SwiftUI

struct WarningLevelView: View {
    private let size = CGFloat(30)
    @Binding var warningLevel: Double
    var body: some View {
        if 0 <= warningLevel && warningLevel <= 1/3 {
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: size, height: size)
                .foregroundColor(.green)
        } else if 1/3 < warningLevel && warningLevel < 2/3 {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .frame(width: size, height: size)
                .foregroundColor(.yellow)
        } else if 2/3 <= warningLevel {
            Image(systemName: "xmark.octagon")
                .resizable()
                .frame(width: size, height: size)
                .foregroundColor(.red)
        } else {
            Image(systemName: "questionmark.circle")
                .resizable()
                .frame(width: size, height: size)
                .foregroundColor(.blue)
        }
    }
}

struct WarningLevelView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            WarningLevelView(warningLevel: .constant(0.1))
            WarningLevelView(warningLevel: .constant(0.5))
            WarningLevelView(warningLevel: .constant(0.9))
            WarningLevelView(warningLevel: .constant(-1))
        }
    }
}
