//
//  Copyright © 2017 Beeline. All rights reserved.
//

extension String {

    func xmlEscape() -> String {
        return replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "<", with: "&lt;")
    }

}
