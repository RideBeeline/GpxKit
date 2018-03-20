//
//  Copyright © 2017 Beeline. All rights reserved.
//

import RxBlocking
@testable import GpxKit

extension GpxWriter {

    func asString() -> String {
        let data = try! write(to: OutputStream(toMemory: ()))
            .toBlocking()
            .single()
            .property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
        return String(data: data, encoding: String.Encoding.utf8)!
    }

}
