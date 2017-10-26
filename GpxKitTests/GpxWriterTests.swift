//
//  Copyright © 2017 Beeline. All rights reserved.
//

import XCTest
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

    private func gpxFile(_ name: String) -> String {
        let url = Bundle(for: GpxParserTests.self).url(forResource: name, withExtension: "gpx")
        let data = try! Data(contentsOf: url!)
        return String(data: data, encoding: String.Encoding.utf8)!
    }

}
