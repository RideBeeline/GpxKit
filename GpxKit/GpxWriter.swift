//
//  Copyright © 2017 Beeline. All rights reserved.
//

import CoreLocation
import RxSwift

fileprivate typealias XmlWrite = (OutputStream) -> Void

public class GpxWriter : NSObject {

    private let writeOperations: Observable<XmlWrite>

    public init(
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
            .concat(writeTrack(track, indent: 1))
            .concat(Observable.just { $0.write(closeTag: "gpx", newline: true) })
        super.init()
    }

    public func write<T : OutputStream>(to stream: T) -> Observable<T> {
        return writeOperations
            .startWith { $0.open() }
            .concat(Observable.just { $0.close() })
            .reduce(stream) { stream, operation -> T in
                operation(stream)
                return stream
            }
    }

}

private func writePoint(point: Point, tag: String, indent: Int = 0) -> XmlWrite {
    return { stream in
        stream.write(
            openTag: tag,
            attributes: [("lat", "\(point.coordinate.latitude)"), ("lon", "\(point.coordinate.longitude)")],
            newline: true,
            indent: indent
        )
        if let elevation = point.elevation {
            stream
                .write(openTag: "ele", indent: indent + 1)
                .write(value: "\(elevation)")
                .write(closeTag: "ele", newline: true)
        }
        if let time = point.time {
            stream
                .write(openTag: "time", indent: indent + 1)
                .write(value: DateFormatter.iso8601.string(from: time))
                .write(closeTag: "time", newline: true)
        }
        stream.write(
            closeTag: tag,
            newline: true,
            indent: indent
        )
    }
}

private func writeMetadata(_ metadata: Metadata?, indent: Int = 0) -> Observable<XmlWrite> {
    guard let metadata = metadata else { return Observable.empty() }
    return Observable.just { stream in
        stream.write(openTag: "metadata", newline: true, indent: indent)
        if let value = metadata.name {
            stream
                .write(openTag: "name", indent: indent + 1)
                .write(value: value)
                .write(closeTag: "name", newline: true)
        }
        if let value = metadata.description {
            stream
                .write(openTag: "description", indent: indent + 1)
                .write(value: value)
                .write(closeTag: "description", newline: true)
        }
        stream.write(closeTag: "metadata", newline: true, indent: indent)
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

private func writeTrack(_ track: Observable<Observable<Point>>?, indent: Int = 0) -> Observable<XmlWrite> {
    guard let track = track else { return Observable.empty() }
    return Observable.just { $0.write(openTag: "trk", newline: true, indent: indent) }
        .concat(
            Observable.just { $0.write(openTag: "trkseg", newline: true, indent: indent + 1) }
                .concat(
                    track.concatMap {
                        $0.map { writePoint(point: $0, tag: "trkpt", indent: indent + 2) }
                    }
                )
                .concat(Observable.just { $0.write(closeTag: "trkseg", newline: true, indent: indent + 1) })
        )
        .concat(Observable.just { $0.write(closeTag: "trk", newline: true, indent: indent) })
}

