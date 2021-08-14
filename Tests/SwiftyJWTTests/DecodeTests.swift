import XCTest
@testable import SwiftyJWT

let secret_key: String = "polarsecret"

final class SwiftyJWTDecodeTests: XCTestCase {
    
    
    func testDecodingValidJWT() throws {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoicG9sYXIifQ.LUOF8nSVWHNft1UbGd65gU4e8PeGrCvaDa1OTjUc4tc"
        
        let claims = try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!))
        XCTAssertEqual(claims["name"] as? String, "polar")
    }
    
    func testFailsToDecodeInvalidStringWithoutThreeSegments() {
        XCTAssertThrowsError(try SwiftyJWT.decode("a.b", algorithm: .none), "Not enough segments")
    }
    
    // MARK: Disable verify
    func testDisablingVerify() throws {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.2_8pWJfyPup0YwOXK7g9Dn0cF1E3pdn299t4hSeJy5w"
        _ = try SwiftyJWT.decode(jwt, algorithm: .none, verify: false, issuer: "www.polarcop.com")
    }
    
    // MARK: Issuer claim
    func testSuccessfulIssuerValidation() throws {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ3d3cucG9sYXJjb3AuY29tIn0.-kGZ0_vi9cI--0ENTfYixtcIqpuwTiThomSJtlu8INw"
        
        let claims = try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!))
        XCTAssertEqual(claims.issuer, "www.polarcop.com")
    }
    
    func testIncorrectIssuerValidation() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ3d3cucG9sYXJjb3AuY29tIn0.-kGZ0_vi9cI--0ENTfYixtcIqpuwTiThomSJtlu8INw"
        XCTAssertThrowsError(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!), issuer: "fake.polarcop.com"))
    }
    
    func testMissingIssuerValidation() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.WjB4rr14UW1MLn2L8Qi-q3pJRZg5cGoU949YxQo9lDs"
        XCTAssertThrowsError(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!), issuer: "www.polarcop.com"))
    }
    
    // MARK: Expiration claim
    func testExpiredClaim() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MjA3NzgxODB9.iBIO_-ghTt3LLLUpISIb1RlitwaynF3rEfSZmCVSris"
        XCTAssertThrowsError(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!)))
    }
    
    func testInvalidExpiryClaim() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOlsiMTUyMDc3ODE4MCJdfQ.m60WVW3LrLBUL_cMASYrPRviwiPq3VqFGySvWd4bOrQ"
        XCTAssertThrowsError(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!)))
    }
    
    func testUnexpiredClaim() throws {
        // If this just started failing, hello 2027!
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3OTg3NTgwMDB9.aLKP43ExpvUgAkrIPLBBxNY4bYlpv78w8NaVBEPA_vQ"
        
        let claims = try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!))
        XCTAssertEqual(claims.expiration?.timeIntervalSince1970, 1798758000)
    }
    
    func testUnexpiredClaimString() throws {
        // If this just started failing, hello 2027!
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOiIxNzk4NzU4MDAwIn0.ECMTRvIIVm4mSJrJLawc4KM1oNBnAD0ar0D96PHvD9k"
        
        let claims = try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!))
        XCTAssertEqual(claims.expiration?.timeIntervalSince1970, 1798758000)
    }
    
    // MARK: Not before claim
    func testNotBeforeClaim() throws {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE1MjA3NzgxODB9.SCWM14awTxw7nF_t1kZ70MEJbGwhgpjDv_yuu6X2Hd0"
        
        let claims = try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!))
        XCTAssertEqual(claims.notBefore?.timeIntervalSince1970, 1520778180)
    }
    
    func testNotBeforeClaimString() throws {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOiIxNTIwNzc4MTgwIn0.K7RFh-kMjIUwQRqmA6Df-B8y5hrFJ7GK4SZ5l45No-8"
        
        let claims = try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!))
        XCTAssertEqual(claims.notBefore?.timeIntervalSince1970, 1520778180)
    }
    
    func testInvalidNotBeforeClaim() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOlsxNTIwNzc4MTgwXX0.sDSdvXGlDqXvUyq2p1_7pWccdDa544bWAMP0wxXoA5M"
        assertDecodeError(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!)), error: "Not before claim (nbf) must be an integer")
    }
    
    func testUnmetNotBeforeClaim() {
        // If this just started failing, hello 2027!
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE3OTg3NTgwMDB9.mrSaQ8SLdq9EeLjqGpqVLpwfaa_Q-OV0OuypX8FHAuY"
        XCTAssertThrowsError(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!)))
    }
    
    // MARK: Issued at claim
    func testIssuedAtClaimInThePast() throws {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1MjA3NzgxODB9.fvpxJoEUfznMyWAwVfYxgDsFH-NPMuSZ3kuFnzpHDkM"
        
        let claims = try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!))
        XCTAssertEqual(claims.issuedAt?.timeIntervalSince1970, 1520778180)
    }
    
    func testIssuedAtClaimInThePastString() throws {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOiIxNTIwNzc4MTgwIn0.jyw9bCQkSgio4Q7_Ttd7HCJyBj7h_e7HVDNQRsA6Rq0"
        
        let claims = try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!))
        XCTAssertEqual(claims.issuedAt?.timeIntervalSince1970, 1520778180)
    }
    
    func testIssuedAtClaimInTheFuture() {
        // If this just started failing, hello 2024!
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3OTg3NTgwMDB9.i5jTItzlXzp76lvGlwk1bkL2i-1l9wf-hDMXIBUKRVE"
        XCTAssertThrowsError(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!)))
    }
    
    func testInvalidIssuedAtClaim() {
        // If this just started failing, hello 2024!
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOlsxNzk4NzU4MDAwXX0.q_Dzyq0VMSQqCbuek8-VkaxVhYRphgIPtsgJjsXYQmU"
        assertDecodeError(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!)), error: "Issued at claim (iat) must be an integer")
    }
    
    // MARK: Audience claims
    func testAudiencesClaim() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsiaW9zIiwiZGVza3RvcCJdfQ.lJg5B-km_y9oXib8mEUm6YSo_UYYUVQxsTDJzEbftBk"
        assertSuccess(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!), audience: "ios")) { payload in
            XCTAssertEqual(payload.count, 1)
            XCTAssertEqual(payload["aud"] as! [String], ["ios", "desktop"])
        }
    }
    
    func testAudienceClaim() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJpb3MifQ.vp6NpzsVcLVDL0K9CtqshFlzdipMN7RMoSO_Xf5IUCg"
        assertSuccess(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!), audience: "ios")) { payload in
            XCTAssertEqual(payload as! [String: String], ["aud": "ios"])
        }
    }
    
    func testMismatchAudienceClaim() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJkZXNrdG9wIn0.tt4rcaUdHHv_-3P9cnyyBLVShCsePGg1fD7ixWYlsn0"
        XCTAssertThrowsError(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!), audience: "ios"))
    }
    
    func testMissingAudienceClaim() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.WjB4rr14UW1MLn2L8Qi-q3pJRZg5cGoU949YxQo9lDs"
        XCTAssertThrowsError(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!), audience: "ios"))
    }
    
    // MARK: Signature verification
    func testNoneAlgorithm() {
        let jwt = "eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJ0ZXN0IjoiaW5nIn0."
        assertSuccess(try SwiftyJWT.decode(jwt, algorithm: .none)) { payload in
            XCTAssertEqual(payload as! [String: String], ["test": "ing"])
        }
    }
    
    func testNoneFailsWithSecretAlgorithm() {
        let jwt = "eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJ0ZXN0IjoiaW5nIn0."
        XCTAssertThrowsError(try SwiftyJWT.decode(jwt, algorithm: .hs256(secret_key.data(using: .utf8)!)))
    }
    
    func testMatchesAnyAlgorithm() {
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.2_8pWJfyPup0YwOXK7g9Dn0cF1E3pdn299t4hSeJy5w."
        assertFailure(try SwiftyJWT.decode(jwt, algorithms: [.hs256("anothersecret".data(using: .utf8)!), .hs256("secret".data(using: .utf8)!)]))
    }
    
    func testHS384Algorithm() {
        let jwt = "eyJhbGciOiJIUzM4NCIsInR5cCI6IkpXVCJ9.eyJzb21lIjoicGF5bG9hZCJ9.lddiriKLoo42qXduMhCTKZ5Lo3njXxOC92uXyvbLyYKzbq4CVVQOb3MpDwnI19u4"
        assertSuccess(try SwiftyJWT.decode(jwt, algorithm: .hs384("secret".data(using: .utf8)!))) { payload in
            XCTAssertEqual(payload as! [String: String], ["some": "payload"])
        }
    }
    
    func testHS512Algorithm() {
        let jwt = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzb21lIjoicGF5bG9hZCJ9.WTzLzFO079PduJiFIyzrOah54YaM8qoxH9fLMQoQhKtw3_fMGjImIOokijDkXVbyfBqhMo2GCNu4w9v7UXvnpA"
        assertSuccess(try SwiftyJWT.decode(jwt, algorithm: .hs512("secret".data(using: .utf8)!))) { claims in
            XCTAssertEqual(claims as! [String: String], ["some": "payload"])
        }
    }
}

// MARK: Helpers
func assertSuccess(_ decoder: @autoclosure () throws -> ClaimSet, closure: (([String: Any]) -> Void)? = nil) {
    do {
        let claims = try decoder()
        closure?(claims.claims as [String: Any])
    } catch {
        XCTFail("Failed to decode while expecting success. \(error)")
    }
}

func assertFailure(_ decoder: @autoclosure () throws -> ClaimSet, closure: ((SwiftyJWT.JWTErrors.InvalidToken) -> Void)? = nil) {
    do {
        _ = try decoder()
        XCTFail("Decoding succeeded, expected a failure.")
    } catch let error as SwiftyJWT.JWTErrors.InvalidToken {
        closure?(error)
    } catch {
        XCTFail("Unexpected error")
    }
}

func assertDecodeError(_ decoder: @autoclosure () throws -> ClaimSet, error: String) {
    assertFailure(try decoder()) { failure in
        switch failure {
        case .decodeError(let decodeError):
            if decodeError != error {
                XCTFail("Incorrect decode error \(decodeError) != \(error)")
            }
        default:
            XCTFail("Failure for the wrong reason \(failure)")
        }
    }
}
