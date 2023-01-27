//
//  SoundbarView.swift
//  waldlaeufer
//
//  Created by Andreas Wenzelhuemer on 04.01.23.
//
//

import SwiftUI

struct SoundbarView: View {

    var value: CGFloat
    let numberOfSamples: Int

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                        startPoint: .top,
                        endPoint: .bottom))
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: value)
    }
}

struct SoundbarView_Previews: PreviewProvider {
    static var previews: some View {
        SoundbarView(value: 5.0, numberOfSamples: 10)
    }
}
