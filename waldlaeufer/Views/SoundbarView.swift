//
//  SoundbarView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 04.01.23.
//
//

import SwiftUI

struct SoundbarView: View {

    var item: SoundbarItem
    let numberOfSamples: Int

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                        startPoint: .top,
                        endPoint: .bottom))
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: normalizeLevel(item.value))
    }

    private func normalizeLevel(_ level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        return CGFloat(level * (200 / 25)) // scaled to our height of our bar
    }
}

struct SoundbarView_Previews: PreviewProvider {
    static var previews: some View {
        SoundbarView(item: SoundbarItem(value: 5), numberOfSamples: 10)
    }
}
