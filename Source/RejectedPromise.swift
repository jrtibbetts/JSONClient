//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation
import PromiseKit

/// A `Promise` that can be initialized with an `Error` that will automatically
/// be rejected.
open class RejectedPromise<T>: Promise<T> {

    /// Create a `Promise` that will do nothing but reject a specified `Error`.
    /// Note that this is `required` because it's one particular type of the
    /// `init(value:)` initializer.
    ///
    /// - parameter error: The error that's causing the rejection.
    public required init(error: Error) {
        super.init() { (_, reject) in
            reject(error)
        }
    }

    /// Create a regular `Promise`. This is a required implementation that does
    /// nothing but call the superclass's initializer.
    required public init(resolvers: (@escaping (T) -> Void, @escaping (Error) -> Void) throws -> Void) {
        super.init(resolvers: resolvers)
    }

    /// Create a regular `Promise` with a value. This is a required
    /// implementation that simply calls the superclass's initializer.
    required public init(value: T) {
        super.init(value: value)
    }

}
