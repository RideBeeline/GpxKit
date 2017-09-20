//
//  Copyright © 2017 Beeline. All rights reserved.
//

import CoreLocation
import SWXMLHash

public extension Gpx {

    public init(data: Data) throws {
        let gpx = SWXMLHash.parse(data)["gpx"]

        self.route = try gpx["rte"]["rtept"].all.map { routePoint in
            try routePoint.point()
        }

        self.track = try gpx["trk"]["trkseg"].all.map { trackSegment in
            try trackSegment["trkpt"].all.map { trackPoint in
                try trackPoint.point()
            }
        }
    }
}

fileprivate extension XMLIndexer {

    func point() throws -> Point {
        guard let element = element else { throw IndexingError.error }
        let latitude = try element.attributeValue(by: "lat")
        let longitude = try element.attributeValue(by: "lon")
        return Point(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
}

fileprivate extension XMLElement {

    func attributeValue(by name: String) throws -> Double {
        guard let attribute = attribute(by: name) else {
            throw IndexingError.attribute(attr: name)
        }
        guard let value = Double(attribute.text) else {
            throw IndexingError.attributeValue(attr: name, value: attribute.text)
        }
        return value
    }
}
