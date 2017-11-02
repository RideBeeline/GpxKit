//
//  Copyright © 2017 Beeline. All rights reserved.
//

import XCTest
import RxSwift
import CoreLocation
@testable import GpxKit

class GpxWriterTests: XCTestCase {

    func test_write_gpx_empty() {
        XCTAssertEqual(
            gpxFile("Empty"),
            GpxWriter(
                creator: "GpxKit"
            ).asString()
        )
    }

    func test_write_gpx_metadata() {
        XCTAssertEqual(
            gpxFile("EmptyWithMetadata"),
            GpxWriter(
                creator: "GpxKit",
                metadata: Metadata(name: "Empty with metadata", description: "An empty GPX file")
            ).asString()
        )
    }

    func test_write_gpx_waypoints() {
        XCTAssertEqual(
            gpxFile("Waypoints"),
            GpxWriter(
                creator: "RouteConverter",
                metadata: Metadata(name: "Test file by Patrick", description: "A test file from cycleseven.org"),
                waypoints: Observable.from([
                    Point(lat: 54.9328621088893, lon: 9.860624216140083),
                    Point(lat: 54.93293237320851, lon: 9.86092208681491),
                    Point(lat: 54.93327743521187, lon: 9.86187816543752),
                    Point(lat: 54.93342326167919, lon: 9.862439849679859)
                ])
            ).asString()
        )
    }

    func test_write_gpx_route() {
        XCTAssertEqual(
            gpxFile("Route"),
            GpxWriter(
                creator: "GpxKit",
                route: Observable.from([
                    Point(lat: 54.9328621088893, lon: 9.860624216140083),
                    Point(lat: 54.93293237320851, lon: 9.86092208681491),
                    Point(lat: 54.93327743521187, lon: 9.86187816543752),
                    Point(lat: 54.93342326167919, lon: 9.862439849679859)
                ])
            ).asString()
        )
    }

    func test_write_gpx_track() {
        XCTAssertEqual(
            gpxFile("Track"),
            GpxWriter(
                creator: "GpxKit",
                track: Observable.just(Observable.from([
                    Point(lat: 54.9328621088893, lon: 9.860624216140083, elevation: 0, time: Date(timeIntervalSince1970: 1505900660)),
                    Point(lat: 54.93293237320851, lon: 9.86092208681491, elevation: 1.1, time: Date(timeIntervalSince1970: 1505900661)),
                    Point(lat: 54.93327743521187, lon: 9.86187816543752, elevation: 2.22, time: Date(timeIntervalSince1970: 1505900662)),
                    Point(lat: 54.93342326167919, lon: 9.86243984967986, elevation: 3.333, time: Date(timeIntervalSince1970: 1505900663))
                ]))
            ).asString()
        )
    }

    private func gpxFile(_ name: String) -> String {
        let url = Bundle(for: GpxParserTests.self).url(forResource: name, withExtension: "gpx")
        let data = try! Data(contentsOf: url!)
        return String(data: data, encoding: String.Encoding.utf8)!
    }

}
