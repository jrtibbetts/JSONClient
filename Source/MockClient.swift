//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation
import PromiseKit

/// Base class for mock client implementations of third-party services.
open class MockClient: JSONClient {

    /// If `true`, each API call will pass a non-`nil` `Error` object to the
    /// completion block instead of a valid data object.
    public var errorMode: Bool = false

    /// The bundle that contains this implementation and the local JSON data
    /// files that is parses to return data.
    public private(set) var bundle: Bundle

    fileprivate let errorDomain: String

    public init(bundle: Bundle = Bundle.main) {
        self.errorMode = false
        self.errorDomain = "Error domains aren't used in non-error mode!"
        self.bundle = bundle
        super.init()
    }

    public init(errorDomain: String,
                bundle: Bundle = Bundle.main) {
        self.errorMode = true
        self.errorDomain = errorDomain
        self.bundle = bundle
        super.init()
    }

    // MARK: - Utilities

    public func apply<T: Codable>(toJsonObjectIn fileName: String,
                                  error: Error? = nil) -> Promise<T> {
        return Promise<T> { (fulfill, reject) in
            if errorMode {
                if let customError = error {
                    reject(customError)
                } else {
                    let defaultError = NSError(domain: errorDomain, code: 0, userInfo: nil)
                    reject(defaultError)
                }
            } else {
                do {
                    let obj: T = try JSONUtils.jsonObject(forFileNamed: fileName, inBundle: bundle)
                    fulfill(obj)
                } catch {
                    reject(error)
                }
            }
        }
    }

}
