//
//  Copyright © 2017 Beeline. All rights reserved.
//

import XCTest
@testable import GpxKit

class GpxParserTests: XCTestCase {

    func test_parse_gpx_route() {
        let gpx = try! parse(name: "Route")

        XCTAssertEqual(gpx.route!.count, 118)

        XCTAssertEqual(gpx.route![0].coordinate.latitude, 49.933832287788391)
        XCTAssertEqual(gpx.route![0].coordinate.longitude, 1.088794218376279)

        XCTAssertEqual(gpx.route![1].coordinate.latitude, 49.934062957763672)
        XCTAssertEqual(gpx.route![1].coordinate.longitude, 1.089534759521484)
    }

    func test_parse_gpx_track() {
        let gpx = try! parse(name: "Track")

        XCTAssertEqual(gpx.track!.count, 1)
        XCTAssertEqual(gpx.track![0].count, 1752)

        XCTAssertEqual(gpx.track![0][0].coordinate.latitude, 50.732060000000004)
        XCTAssertEqual(gpx.track![0][0].coordinate.longitude, -1.8740900000000003)

        XCTAssertEqual(gpx.track![0][1].coordinate.latitude, 50.731970000000004)
        XCTAssertEqual(gpx.track![0][1].coordinate.longitude, -1.87399)
    }

    func test_parse_gpx_waypoints() {
        let gpx = try! parse(name: "Waypoints")

        XCTAssertEqual(gpx.waypoints!.count, 4)

        XCTAssertEqual(gpx.waypoints![0].coordinate.latitude, 54.9328621088893)
        XCTAssertEqual(gpx.waypoints![0].coordinate.longitude, 9.86062421614008)

        XCTAssertEqual(gpx.waypoints![1].coordinate.latitude, 54.9329323732085)
        XCTAssertEqual(gpx.waypoints![1].coordinate.longitude, 9.86092208681491)

        XCTAssertEqual(gpx.waypoints![2].coordinate.latitude, 54.9332774352119)
        XCTAssertEqual(gpx.waypoints![2].coordinate.longitude, 9.86187816543752)

        XCTAssertEqual(gpx.waypoints![3].coordinate.latitude, 54.9334232616792)
        XCTAssertEqual(gpx.waypoints![3].coordinate.longitude, 9.86243984967986)
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

    private func parse(name: String) throws -> Gpx {
        let url = Bundle(for: GpxParserTests.self).url(forResource: name, withExtension: "gpx")
        let data = try! Data(contentsOf: url!)
        return try Gpx(data: data)
    }
}
