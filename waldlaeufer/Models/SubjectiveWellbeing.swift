//
// Created by Andreas Wenzelhuemer on 03.01.23.
//

import Foundation

enum SubjectiveWellbeing: Int, Codable, CaseIterable {
    case REALLY_GOOD = 0
    case GOOD = 1
    case BAD = 2
    case REALLY_BAD = 3

    var description: String {
        switch self {
        case .GOOD:
            return "Good"
        case .BAD:
            return "Bad"
        case .REALLY_BAD:
            return "Really Bad"
        case .REALLY_GOOD:
            return "Really Good"
        }
    }
}
