import XCTest
@testable import SwiftyJWT

final class SwiftyJWTEncodeTests: XCTestCase {
    func testEncodingJWT() {
        let payload = ["device": "ios"] as Payload
        let jwt = SwiftyJWT.encode(claims: payload, algorithm: .hs256(secret_key.data(using: .utf8)!))
        
        let expected = [
            // { "alg": "HS256", "typ": "JWT" }
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkZXZpY2UiOiJpb3MifQ.eUen9e9tvGalt9mbCQssqIk4DLoh1nJKkiC3DALmau0",
            
            // {  "typ": "JWT", "alg": "HS256" }
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkZXZpY2UiOiJpb3MifQ.OGntPmVS8NN8i6JVT-v3G64dBVeoOTEe9yYUXtxoy5M"
        ]
        
        XCTAssertTrue(expected.contains(jwt))
    }
    
    func testEncodingWithBuilder() {
        let algorithm = Algorithm.hs256(secret_key.data(using: .utf8)!)
        let jwt = SwiftyJWT.encode(algorithm) { builder in
            builder.issuer = "www.polarcop.com"
        }
        
        let expected = [
            // { "alg": "HS256", "typ": "JWT" }
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ3d3cucG9sYXJjb3AuY29tIn0.-kGZ0_vi9cI--0ENTfYixtcIqpuwTiThomSJtlu8INw",
            // { "typ": "JWT", "alg": "HS256" }
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ3d3cucG9sYXJjb3AuY29tIn0.JKQsoOzen4Iug_SxddU_Kiwb3Et-kBxx5Du3o5eXaVM"
        ]
        
        XCTAssertTrue(expected.contains(jwt))
    }
    
    func testEncodingClaimsWithHeaders() {
        let algorithm = Algorithm.hs256("secret".data(using: .utf8)!)
        let jwt = SwiftyJWT.encode(claims: ClaimSet(), algorithm: algorithm, headers: ["kid": "x"])
        
        let expected = [
            // { "alg": "HS256", "typ": "JWT", "kid": "x" }
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IngifQ.e30.ddEotxYYMMdat5HPgYFQnkHRdPXsxPG71ooyhIUoqGA",
            // { "alg": "HS256", "kid": "x", "typ": "JWT" }
            "eyJhbGciOiJIUzI1NiIsImtpZCI6IngiLCJ0eXAiOiJKV1QifQ.e30.xiT6fWe5dWGeuq8zFb0je_14Maa_9mHbVPSyJhUIJ54",
            // { "typ": "JWT", "alg": "HS256", "kid": "x" }
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IngifQ.e30.5t6a61tpSXFo5QBHYCnKAz2mTHrW9kaQ9n_b7e-jWw0",
            // { "typ": "JWT", "kid": "x", "alg": "HS256" }
            "eyJ0eXAiOiJKV1QiLCJraWQiOiJ4IiwiYWxnIjoiSFMyNTYifQ.e30.DG5nmV2CVH6mV_iEm0xXZvL0DUJ22ek2xy6fNi_pGLc",
            // { "kid": "x", "typ": "JWT", "alg": "HS256" }
            "eyJraWQiOiJ4IiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e30.h5ZvlqECBIvu9uocR5_5uF3wnhga8vTruvXpzaHpRdA",
            // { "kid": "x", "alg": "HS256", "typ": "JWT" }
            "eyJraWQiOiJ4IiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.e30.5KqN7N5a7Cfbe2eKN41FJIfgMjcdSZ7Nt16xqlyOeMo"
        ]
        
        XCTAssertTrue(expected.contains(jwt))
    }
}

