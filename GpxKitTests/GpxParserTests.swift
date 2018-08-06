//
//  Copyright © 2017 Beeline. All rights reserved.
//

import XCTest
import CoreLocation
@testable import GpxKit

class GpxParserTests: XCTestCase {

    func test_parse_gpx_route() {
        let gpx = try! parse(name: "GarminRoute")

        XCTAssertEqual(gpx.route.count, 118)

        XCTAssertEqual(gpx.route[0].coordinate.latitude, 49.933832287788391)
        XCTAssertEqual(gpx.route[0].coordinate.longitude, 1.088794218376279)
        XCTAssertEqual(gpx.route[0].time, Date(timeIntervalSince1970: 1311371614))

        XCTAssertEqual(gpx.route[1].coordinate.latitude, 49.934062957763672)
        XCTAssertEqual(gpx.route[1].coordinate.longitude, 1.089534759521484)
        XCTAssertEqual(gpx.route[1].time, nil)
    }

    func test_parse_gpx_track() {
        let gpx = try! parse(name: "StravaTrack")

        XCTAssertEqual(gpx.tracks.count, 1)
        let track = gpx.tracks[0]
        XCTAssertEqual(track.segments[0].count, 1752)

        XCTAssertEqual(track.segments[0][0].coordinate.latitude, 50.732060000000004)
        XCTAssertEqual(track.segments[0][0].coordinate.longitude, -1.8740900000000003)

        XCTAssertEqual(track.segments[0][1].coordinate.latitude, 50.731970000000004)
        XCTAssertEqual(track.segments[0][1].coordinate.longitude, -1.87399)
    }

    func test_parse_gpx_waypoints() {
        let gpx = try! parse(name: "Waypoints")

        XCTAssertEqual(gpx.waypoints.count, 4)

        XCTAssertEqual(gpx.waypoints[0].coordinate.latitude, 54.9328621088893)
        XCTAssertEqual(gpx.waypoints[0].coordinate.longitude, 9.86062421614008)

        XCTAssertEqual(gpx.waypoints[1].coordinate.latitude, 54.9329323732085)
        XCTAssertEqual(gpx.waypoints[1].coordinate.longitude, 9.86092208681491)

        XCTAssertEqual(gpx.waypoints[2].coordinate.latitude, 54.9332774352119)
        XCTAssertEqual(gpx.waypoints[2].coordinate.longitude, 9.86187816543752)

        XCTAssertEqual(gpx.waypoints[3].coordinate.latitude, 54.9334232616792)
        XCTAssertEqual(gpx.waypoints[3].coordinate.longitude, 9.86243984967986)
    }

    func test_parse_gpx_with_multiple_tracks() {
        let gpx = try! parse(name: "Track-Multiple")

        XCTAssertEqual(gpx.tracks.count, 2)

        let track1 = gpx.tracks[0]
        XCTAssertEqual(track1.segments[0].count, 4)

        XCTAssertEqual(track1.segments[0][0].coordinate, CLLocationCoordinate2D(latitude: 54.9328621088893, longitude: 9.86062421614008))
        XCTAssertEqual(track1.segments[0][0].elevation, 0.0)

        XCTAssertEqual(track1.segments[0][1].coordinate, CLLocationCoordinate2D(latitude: 54.9329323732085, longitude: 9.86092208681491))
        XCTAssertEqual(track1.segments[0][1].elevation, 1.1)

        XCTAssertEqual(track1.segments[0][2].coordinate, CLLocationCoordinate2D(latitude: 54.9332774352119, longitude: 9.86187816543752))
        XCTAssertEqual(track1.segments[0][2].elevation, 2.22)

        XCTAssertEqual(track1.segments[0][3].coordinate, CLLocationCoordinate2D(latitude: 54.9334232616792, longitude: 9.86243984967986))
        XCTAssertEqual(track1.segments[0][3].elevation, 3.333)

        let track2 = gpx.tracks[1]
        XCTAssertEqual(track2.segments[0].count, 3)

        XCTAssertEqual(track2.segments[0][0].coordinate, CLLocationCoordinate2D(latitude: 49.933832287788391, longitude: 1.088794218376279))
        XCTAssertEqual(track2.segments[0][0].elevation, nil)

        XCTAssertEqual(track2.segments[0][1].coordinate, CLLocationCoordinate2D(latitude: 49.933706223964691, longitude: 1.091079125180841))
        XCTAssertEqual(track2.segments[0][1].elevation, nil)

        XCTAssertEqual(track2.segments[0][2].coordinate, CLLocationCoordinate2D(latitude: 49.934062957763672, longitude: 1.092946529388428))
        XCTAssertEqual(track2.segments[0][2].elevation, nil)
    }

    func test_parse_gpx_metadata() {
        let gpx = try! parse(name: "Waypoints")

        XCTAssertEqual(gpx.metadata!.name, "Test file by Patrick")
        XCTAssertEqual(gpx.metadata!.description, "A test file from cycleseven.org")
    }

    func test_parse_gpx_with_invalid_attribute() {
        do {
            _ = try parse(name: "Invalid-Attribute")
            XCTFail()
        } catch {
            // Pass
        }
    }

    func test_parse_gpx_with_invalid_attribute_value() {
        do {
            _ = try parse(name: "Invalid-Attribute-Value")
            XCTFail()
        } catch {
            // Pass
        }
    }
    
    func test_parse_gpx_track_with_elevation() {
        let gpx = try! parse(name: "Track")

        XCTAssertEqual(gpx.tracks.count, 1)

        let track = gpx.tracks[0]
        XCTAssertEqual(track.segments[0].count, 4)

        XCTAssertEqual(track.segments[0][0].coordinate, CLLocationCoordinate2D(latitude: 54.9328621088893, longitude: 9.86062421614008))
        XCTAssertEqual(track.segments[0][0].elevation, 0.0)

        XCTAssertEqual(track.segments[0][1].coordinate, CLLocationCoordinate2D(latitude: 54.9329323732085, longitude: 9.86092208681491))
        XCTAssertEqual(track.segments[0][1].elevation, 1.1)

        XCTAssertEqual(track.segments[0][2].coordinate, CLLocationCoordinate2D(latitude: 54.9332774352119, longitude: 9.86187816543752))
        XCTAssertEqual(track.segments[0][2].elevation, 2.22)

        XCTAssertEqual(track.segments[0][3].coordinate, CLLocationCoordinate2D(latitude: 54.9334232616792, longitude: 9.86243984967986))
        XCTAssertEqual(track.segments[0][3].elevation, 3.333)
    }
    
    func test_parse_gpx_track_with_invalid_elevation() {
        let gpx = try! parse(name: "TrackInvalidElevation")

        XCTAssertEqual(gpx.tracks.count, 1)

        let track = gpx.tracks[0]
        XCTAssertEqual(track.segments[0].count, 4)

        XCTAssertEqual(track.segments[0][0].coordinate, CLLocationCoordinate2D(latitude: 54.9328621088893, longitude: 9.86062421614008))
        XCTAssertEqual(track.segments[0][0].elevation, nil)

        XCTAssertEqual(track.segments[0][1].coordinate, CLLocationCoordinate2D(latitude: 54.9329323732085, longitude: 9.86092208681491))
        XCTAssertEqual(track.segments[0][1].elevation, nil)

        XCTAssertEqual(track.segments[0][2].coordinate, CLLocationCoordinate2D(latitude: 54.9332774352119, longitude: 9.86187816543752))
        XCTAssertEqual(track.segments[0][2].elevation, 2.22)

        XCTAssertEqual(track.segments[0][3].coordinate, CLLocationCoordinate2D(latitude: 54.9334232616792, longitude: 9.86243984967986))
        XCTAssertEqual(track.segments[0][3].elevation, 3.333)
    }

    private func parse(name: String) throws -> Gpx {
        let url = Bundle(for: GpxParserTests.self).url(forResource: name, withExtension: "gpx")
        let data = try! Data(contentsOf: url!)
        return try Gpx(data: data)
    }
}
