import XCTest
@testable import SwiftyJWT

final class SwiftyJWTCompactJSONEncoderTests: XCTestCase {
    let encoder = CompactJSONEncoder()
    
    class CompactJSONEncodable: Encodable {
        let key: String
        
        init(key: String) {
            self.key = key
        }
    }
    
    
    func testEncode() throws {
        let value = CompactJSONEncodable(key: "value")
        let encoded = try encoder.encode(value)
        XCTAssertEqual(encoded, "eyJrZXkiOiJ2YWx1ZSJ9".data(using: .ascii)!)
    }
}
