//
//  Copyright © 2017 Beeline. All rights reserved.
//

import CoreLocation
import RxSwift

fileprivate typealias XmlWrite = (OutputStream) -> Void

public class GpxWriter : NSObject {

    private let writeOperations: Observable<XmlWrite>

    init(
        creator: String,
        metadata: Metadata? = nil,
        waypoints: Observable<Point>? = nil,
        route: Observable<Point>? = nil,
        track: Observable<Observable<Point>>? = nil
    ) {
        self.writeOperations = Observable
            .from([
                { $0.writeXmlDeclaration() },
                { $0.write(
                    openTag: "gpx",
                    attributes: [("xmlns", "http://www.topografix.com/GPX/1/1"), ("version", "1.1"), ("creator", creator)],
                    newline: true
                ) },
            ])
            .concat(writeMetadata(metadata, indent: 1))
            .concat(writeWaypoints(waypoints, indent: 1))
            .concat(writeRoute(route, indent: 1))
            .concat(Observable.just { $0.write(closeTag: "gpx", newline: true) })
        super.init()
    }

    public func write<T : OutputStream>(to stream: T) -> Observable<T> {
        return writeOperations
            .startWith { $0.open() }
            .concat(Observable.just { $0.close() })
            .reduce(stream) { (stream, operation) -> T in
                operation(stream)
                return stream
            }
    }

}

private func writePoint(point: Point, tag: String, indent: Int = 0) -> XmlWrite {
    let lat = "\(point.coordinate.latitude)"
    let lon = "\(point.coordinate.longitude)"
    return {
        $0.write(openTag: tag, attributes: [("lat", lat), ("lon", lon)], newline: true, indent: indent)
        $0.write(closeTag: tag, newline: true, indent: indent)
    }
}

private func writeMetadata(_ metadata: Metadata?, indent: Int = 0) -> Observable<XmlWrite> {
    guard let metadata = metadata else { return Observable.empty() }
    return Observable.just {
        $0.write(openTag: "metadata", newline: true, indent: indent)
        if let value = metadata.name {
            $0.write(openTag: "name", indent: indent + 1).write(value: value).write(closeTag: "name", newline: true)
        }
        if let value = metadata.description {
            $0.write(openTag: "description", indent: indent + 1).write(value: value).write(closeTag: "description", newline: true)
        }
        $0.write(closeTag: "metadata", newline: true, indent: indent)
    }
}

private func writeWaypoints(_ waypoints: Observable<Point>?, indent: Int = 0) -> Observable<XmlWrite> {
    guard let waypoints = waypoints else { return Observable.empty() }
    return waypoints.map { writePoint(point: $0, tag: "wpt", indent: indent) }
}

private func writeRoute(_ route: Observable<Point>?, indent: Int = 0) -> Observable<XmlWrite> {
    guard let route = route else { return Observable.empty() }
    return Observable.just { $0.write(openTag: "rte", newline: true, indent: indent) }
        .concat(route.map { writePoint(point: $0, tag: "rtept", indent: indent + 1) })
        .concat(Observable.just { $0.write(closeTag: "rte", newline: true, indent: indent) })
}
