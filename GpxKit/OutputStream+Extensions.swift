//
//  Copyright © 2017 Beeline. All rights reserved.
//

extension OutputStream {

    private func write(_ data: String) {
        write(data, maxLength: data.lengthOfBytes(using: String.Encoding.utf8))
    }

    @discardableResult
    func writeXmlDeclaration() -> OutputStream {
        write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
        return self
    }

    @discardableResult
    func write(openTag name: String, attributes: [(String, String)] = [], newline: Bool = false) -> OutputStream {
        let attributes = attributes.map { " \($0.xmlEscape())=\"\($1.xmlEscape())\"" }.joined()
        let suffix = newline ? "\n" : ""
        write("<\(name.xmlEscape())\(attributes)>\(suffix)")
        return self
    }

    @discardableResult
    func write(closeTag name: String, newline: Bool = false) -> OutputStream {
        let suffix = newline ? "\n" : ""
        write("</\(name.xmlEscape())>\(suffix)")
        return self
    }

    @discardableResult
    func write(value: String, newline: Bool = false) -> OutputStream {
        let suffix = newline ? "\n" : ""
        write("\(value.xmlEscape())\(suffix)")
        return self
    }

}
