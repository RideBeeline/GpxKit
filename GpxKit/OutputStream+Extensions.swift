//
//  Copyright © 2017 Beeline. All rights reserved.
//

extension OutputStream {

    @discardableResult
    func writeXmlDeclaration() -> OutputStream {
        write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
        return self
    }

    @discardableResult
    func write(openTag name: String, attributes: [(String, String)] = [], newline: Bool = false, indent indentLevel: Int = 0) -> OutputStream {
        let attributes = attributes.map { " \($0.xmlEscape())=\"\($1.xmlEscape())\"" }.joined()
        let suffix = newline ? "\n" : ""
        write("\(indent(indentLevel))<\(name.xmlEscape())\(attributes)>\(suffix)")
        return self
    }

    @discardableResult
    func write(closeTag name: String, newline: Bool = false, indent indentLevel: Int = 0) -> OutputStream {
        let suffix = newline ? "\n" : ""
        write("\(indent(indentLevel))</\(name.xmlEscape())>\(suffix)")
        return self
    }

    @discardableResult
    func write(value: String, newline: Bool = false) -> OutputStream {
        let suffix = newline ? "\n" : ""
        write("\(value.xmlEscape())\(suffix)")
        return self
    }

    private func write(_ data: String) {
        write(data, maxLength: data.lengthOfBytes(using: String.Encoding.utf8))
    }

    private func indent(_ level: Int) -> String {
        return String(repeating: "    ", count: level)
    }

}

private extension String {

    func xmlEscape() -> String {
        return replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "<", with: "&lt;")
    }

}
