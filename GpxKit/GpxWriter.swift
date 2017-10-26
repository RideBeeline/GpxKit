//
//  Copyright © 2017 Beeline. All rights reserved.
//

import CoreLocation
import RxSwift

public class GpxWriter : NSObject {

    private typealias XmlWrite = (OutputStream) -> Void

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
                { $0.write(openTag: "gpx", attributes: [("xmlns", "http://www.topografix.com/GPX/1/1"), ("version", "1.1"), ("creator", creator)], newline: true) },
            ])
            .concat(
                metadata != nil
                    ? Observable.just({ $0.write(metadata: metadata!, indent: 1) })
                    : Observable.empty()
            )
            .concat(
                waypoints != nil
                    ? waypoints!.map { (waypoint: Point) in { $0.write(waypoint: waypoint, indent: 1) } }
                    : Observable.empty()
            )
            .concat(Observable.just { $0.write(closeTag: "gpx", newline: true) })
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

private extension OutputStream {

    @discardableResult
    func write(metadata: Metadata, indent: Int = 0) -> OutputStream {
        write(openTag: "metadata", newline: true, indent: indent)
        if let value = metadata.name {
            write(openTag: "name", indent: indent + 1).write(value: value).write(closeTag: "name", newline: true)
        }
        if let value = metadata.description {
            write(openTag: "description", indent: indent + 1).write(value: value).write(closeTag: "description", newline: true)
        }
        write(closeTag: "metadata", newline: true, indent: indent)
        return self
    }

    @discardableResult
    func write(waypoint: Point, indent: Int = 0) -> OutputStream {
        let lat = "\(waypoint.coordinate.latitude)"
        let lon = "\(waypoint.coordinate.longitude)"
        write(openTag: "wpt", attributes: [("lat", lat), ("lon", lon)], newline: true, indent: indent)
        write(closeTag: "wpt", newline: true, indent: indent)
        return self
    }

}
