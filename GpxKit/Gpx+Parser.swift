//
//  Copyright © 2017 Beeline. All rights reserved.
//

import CoreLocation
import SWXMLHash

public extension Gpx {

    public init(data: Data) throws {
        let gpx = SWXMLHash.parse(data)["gpx"]

        self.creator = gpx["creator"].element?.text ?? ""

        self.metadata = gpx["metadata"].metadata()

        self.waypoints = try gpx["wpt"].all.map { waypoint in
            try waypoint.point()
        }

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

    func metadata() -> Metadata? {
        guard element != nil else { return nil }
        let name = self["name"].element?.text
        let description = self["description"].element?.text
        return Metadata(name: name, description: description)
    }

    func point() throws -> Point {
        guard let element = element else { throw IndexingError.error }
        let latitude = try element.attributeValue(by: "lat")
        let longitude = try element.attributeValue(by: "lon")
        let time = self["time"].element?.text
        return Point(
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            time: time != nil ? ISO8601DateFormatter().date(from: time!) : nil
        )
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
