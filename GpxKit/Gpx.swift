//
//  Copyright © 2017 Beeline. All rights reserved.
//

import CoreLocation

public struct Gpx {
    public let creator: String
    public let metadata: Metadata?
    public let waypoints: [Point]?
    public let route: [Point]?
    public let track: [[Point]]?
}

public struct Metadata {
    public let name: String?
    public let description: String?
}

public struct Point {
    public let coordinate: CLLocationCoordinate2D
    public let elevation: Double?
    public let time: Date?

    init(lat: Double, lon: Double, elevation: Double? = nil, time: Date? = nil) {
        self.init(CLLocationCoordinate2DMake(lat, lon), elevation: elevation, time: time)
    }

    init(_ coordinate: CLLocationCoordinate2D, elevation: Double? = nil, time: Date? = nil) {
        self.coordinate = coordinate
        self.elevation = elevation
        self.time = time
    }
}
