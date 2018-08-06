//
//  Copyright © 2017 Beeline. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {

    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
