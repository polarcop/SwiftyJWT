import XCTest
@testable import SwiftyJWT

final class SwiftyJWTPayloadTests: XCTestCase {
    func testIssuer() {
        _ = SwiftyJWT.encode(.none) { builder in
          builder.issuer = "www.polarcop.com"
          XCTAssertEqual(builder.issuer, "www.polarcop.com")
          XCTAssertEqual(builder["iss"] as? String, "www.polarcop.com")
        }
      }

      func testAudience() {
        _ = SwiftyJWT.encode(.none) { builder in
          builder.audience = "ios"
          XCTAssertEqual(builder.audience, "ios")
          XCTAssertEqual(builder["aud"] as? String, "ios")
        }
      }

      func testExpiration() {
        _ = SwiftyJWT.encode(.none) { builder in
          let date = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
          builder.expiration = date
          XCTAssertEqual(builder.expiration, date)
          XCTAssertEqual(builder["exp"] as? TimeInterval, date.timeIntervalSince1970)
        }
      }

      func testNotBefore() {
        _ = SwiftyJWT.encode(.none) { builder in
          let date = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
          builder.notBefore = date
          XCTAssertEqual(builder.notBefore, date)
          XCTAssertEqual(builder["nbf"] as? TimeInterval, date.timeIntervalSince1970)
        }
      }

      func testIssuedAt() {
        _ = SwiftyJWT.encode(.none) { builder in
          let date = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
          builder.issuedAt = date
          XCTAssertEqual(builder.issuedAt, date)
          XCTAssertEqual(builder["iat"] as? TimeInterval, date.timeIntervalSince1970)
        }
      }

      func testCustomAttributes() {
        _ = SwiftyJWT.encode(.none) { builder in
          builder["user"] = "polar"
          XCTAssertEqual(builder["user"] as? String, "polar")
        }
      }
}
