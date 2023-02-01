//
// Created by Florian Weingartshofer on 01.02.23.
//

import Foundation

extension Float {
    func round(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}