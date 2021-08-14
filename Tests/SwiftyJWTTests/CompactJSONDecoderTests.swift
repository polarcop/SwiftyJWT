import XCTest
@testable import SwiftyJWT

final class SwiftyJWTCompactJSONDecoderTests: XCTestCase {
    let decoder = CompactJSONDecoder()
    
    class CompactJSONDecodable: Decodable {
        let key: String
    }
    
    func testDecoder() throws {
        let expected = "eyJrZXkiOiJ2YWx1ZSJ9".data(using: .ascii)!
        let value = try decoder.decode(CompactJSONDecodable.self, from: expected)
        XCTAssertEqual(value.key, "value")
    }
}
