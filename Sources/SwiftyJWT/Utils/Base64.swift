import Foundation


extension SwiftyJWT.Utils {
    /// A URI safe base 64 encoded string
    static func base64encoded(_ rawData: Data) -> String {
        return rawData.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    /// A URI safe base 64 decoded string
    static func base64decoded(_ encodedString: String) -> Data? {
        let paddingLength = 4 - encodedString.count % 4
        let padding = (paddingLength < 4) ? String(repeating: "=", count: paddingLength) : ""
        let base64EncodedString = encodedString
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
            + padding
        return Data(base64Encoded: base64EncodedString)
    }
}



