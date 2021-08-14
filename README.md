# SwiftyJWT

Heavily based on [Kylef's](https://github.com/kylef/JSONWebToken.swift/) implementation, this library has been refactored for Swift 5.0 and enables Swift Package.

SwiftJWT is a simple Swift library to encode and decode JWT tokens. This library confirms to the [IEFT specification](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-json-web-token-32).

## Installation

**With** [Package Manager](https://swift.org/package-manager/)

```swift
.package(name: "SwiftyJWT", url: "https://github.com/polarcop/SwiftyJWT.git", .upToNextMajor(from: "1.0.0"))
```

## Usage

### Encoding
#### Basic Encoding

```swift
let secret = "secret".data(using: .utf8)!
JWT.encode(claims: ["key": "value"], algorithm: .hs256(secret))
```

#### Advanced Encoding (Claim Set)
```swift
let secret = "secret".data(using: .utf8)!
var claims = ClaimSet()
claims.issuer = "www.polarcop.com"
claims.issuedAt = Date()
claims["key"] = "value"
JWT.encode(claims: claims, algorithm: .hs256(secret))
```

#### Advanced Encoding (Builder)
```swift
let secret = "secret".data(using: .utf8)!
JWT.encode(.hs256(secret)) { builder in
    builder.issuer = "www.polarcop.com"
    builder.issuedAt = Date()
    builder["key"] = "value"
}
```

### Decoding
#### Basic Decoding
```swift
do {
    let secret = "secret".data(using: .utf8)!
    let jwtString: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwb2xhciI6dHJ1ZX0.ip-a_End-3GHD4NSwxhk3wCnMBexxPaxlzWRtJrh3NY"
    let claims: ClaimSet = try JWT.decode(jwtString, algorithm: .hs256(secret))
    print(claims)
} catch let error as SwiftyJWT.JWTErrors.InvalidToken {
    print("JWT Token is invalid: \(error)")
} catch {
    print("Failed to decode JWT: \(error)")
}
```

### License:
Mapper is maintained by [Polar](https://polarcop.com) and released under the Apache 2.0 license. See LICENSE for details


