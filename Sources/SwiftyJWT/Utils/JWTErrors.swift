import Foundation

extension SwiftyJWT {
    public struct JWTErrors {
        /// Failure reasons from decoding a JWT
        public enum InvalidToken: CustomStringConvertible, Error {
            /// Decoding the JWT itself failed
            case decodeError(String)
            
            /// The JWT uses an unsupported algorithm
            case invalidAlgorithm
            
            /// The issued claim has expired
            case expiredSignature
            
            /// The issued claim is for the future
            case immatureSignature
            
            /// The claim is for the future
            case invalidIssuedAt
            
            /// The audience of the claim doesn't match
            case invalidAudience
            
            /// The issuer claim failed to verify
            case invalidIssuer
            
            /// Returns a readable description of the error
            public var description: String {
                switch self {
                case .decodeError(let error):
                    return "Decode Error: \(error)"
                case .invalidIssuer:
                    return "Invalid Issuer"
                case .expiredSignature:
                    return "Expired Signature"
                case .immatureSignature:
                    return "The token is not yet valid (not before claim)"
                case .invalidIssuedAt:
                    return "Issued at claim (iat) is in the future"
                case .invalidAudience:
                    return "Invalid Audience"
                case .invalidAlgorithm:
                    return "Unsupported algorithm or incorrect key"
                }
            }
        }
    }
}
