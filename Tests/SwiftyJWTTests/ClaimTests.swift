import XCTest
@testable import SwiftyJWT

final class SwiftyJWTClaimTests: XCTestCase {
    func testClaimJustExpiredWithoutLeeway() {
        var claims = ClaimSet()
        claims.expiration = Date().addingTimeInterval(-1)
        
        do {
            try claims.validateExpiry()
            XCTFail("InvalidToken.expiredSignature error should have been thrown.")
        } catch SwiftyJWT.JWTErrors.InvalidToken.expiredSignature {
            // Correct error thrown
        } catch {
            XCTFail("Unexpected error while validating exp claim.")
        }
    }
    
    func testClaimJustNotExpiredWithoutLeeway() {
        var claims = ClaimSet()
        claims.expiration = Date().addingTimeInterval(-1)
        
        do {
            try claims.validateExpiry(leeway: 2)
        } catch {
            XCTFail("Unexpected error while validating exp claim that should be valid with leeway.")
        }
    }
    
    func testNotBeforeIsImmatureSignatureWithoutLeeway() {
        var claims = ClaimSet()
        claims.notBefore = Date().addingTimeInterval(1)
        
        do {
            try claims.validateNotBefore()
            XCTFail("InvalidToken.immatureSignature error should have been thrown.")
        } catch SwiftyJWT.JWTErrors.InvalidToken.immatureSignature {
            // Correct error thrown
        } catch {
            XCTFail("Unexpected error while validating nbf claim.")
        }
    }
    
    func testNotBeforeIsValidWithLeeway() {
        var claims = ClaimSet()
        claims.notBefore = Date().addingTimeInterval(1)
        
        do {
            try claims.validateNotBefore(leeway: 2)
        } catch {
            XCTFail("Unexpected error while validating nbf claim that should be valid with leeway.")
        }
    }
    
    func testIssuedAtIsInFutureWithoutLeeway() {
        var claims = ClaimSet()
        claims.issuedAt = Date().addingTimeInterval(1)
        
        do {
            try claims.validateIssuedAt()
            XCTFail("InvalidToken.invalidIssuedAt error should have been thrown.")
        } catch SwiftyJWT.JWTErrors.InvalidToken.invalidIssuedAt {
            // Correct error thrown
        } catch {
            XCTFail("Unexpected error while validating iat claim.")
        }
    }
    
    func testIssuedAtIsValidWithLeeway() {
        var claims = ClaimSet()
        claims.issuedAt = Date().addingTimeInterval(1)
        
        do {
            try claims.validateIssuedAt(leeway: 2)
        } catch {
            XCTFail("Unexpected error while validating iat claim that should be valid with leeway.")
        }
    }
}
