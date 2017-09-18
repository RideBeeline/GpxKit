//
//  Copyright © 2017 Beeline. All rights reserved.
//

import CoreLocation

public struct Gpx {

    public let route: [Point]
    public let track: [[Point]]
}

public struct Point {

    public let coordinate: CLLocationCoordinate2D
}
