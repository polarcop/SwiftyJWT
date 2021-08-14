import XCTest
@testable import SwiftyJWT

final class SwiftyJWTIntegrationTests: XCTestCase {
    func testVerificationFailureWithoutLeeway() {
        let token = SwiftyJWT.encode(.none) { builder in
        builder.issuer = "fuller.li"
        builder.audience = "cocoapods"
        builder.expiration = Date().addingTimeInterval(-1) // Token expired one second ago
        builder.notBefore = Date().addingTimeInterval(1) // Token starts being valid in one second
        builder.issuedAt = Date().addingTimeInterval(1) // Token is issued one second in the future
      }

      do {
        let _ = try SwiftyJWT.decode(token, algorithm: .none, leeway: 0)
        XCTFail("InvalidToken error should have been thrown.")
      } catch is SwiftyJWT.JWTErrors.InvalidToken {
        // Correct error thrown
      } catch {
        XCTFail("Unexpected error type while verifying token.")
      }
    }
}
