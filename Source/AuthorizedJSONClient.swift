//  Copyright © 2018 Poikile Creations. All rights reserved.

import OAuthSwift
import PromiseKit

/// A JSON client that can be authenticated against a server and make
/// authorized REST calls for restricted resources.
open class AuthorizedJSONClient: JSONClient {

    // MARK: - Properties

    /// The client that handles OAuth authorization and inserts the relevant
    /// headers in calls to the server. Subclasses should assign a value to
    /// this once the user successfully authenticates with the server.
    var oAuthClient: OAuthSwiftClient?

    /// The OAuth authentication mode that the client will use for
    /// authorization. This will be either `OAuth1Swift` or `OAuth2Swift`.
    var oAuth: OAuthSwift

    // MARK: - Initialization

    /// Initialize the client with an OAuth type and an optional base URL.
    ///
    /// - parameter oAuth: The OAuth authentication mode. This will be either
    ///             `OAuth1Swift` or `OAuth2Swift`.
    /// - parameter baseUrl: The API URL that all paths will be resolved
    ///             against. If it's `nil` (the default), then each path that's
    ///             passed to the REST functions must be an absolute URL string.
    public init(oAuth: OAuthSwift,
                baseUrl: URL? = nil) {
        self.oAuth = oAuth
        super.init(baseUrl: baseUrl)
    }

    // MARK: - REST methods

    /// `GET` JSON data that requires client authentication to access and
    /// return it as a `Promise` of the desired `Codable` data type.
    open func authorizedGet<T: Codable>(path: String,
                                        headers: Headers = Headers(),
                                        parameters: Parameters = Parameters()) -> Promise<T> {
        guard let url = URL(string: path, relativeTo: baseUrl) else {
            return JSONErr.invalidUrl(urlString: path).rejectedPromise()
        }

        return authorizedGet(url: url, headers: headers, parameters: parameters)
    }

    open func authorizedGet<T: Codable>(url: URL,
                                        headers: Headers = Headers(),
                                        parameters: Parameters = Parameters()) -> Promise<T> {
        guard let oAuthClient = oAuthClient else {
            return JSONErr.unauthorizedAttempt.rejectedPromise()
        }

        return Promise<T> { (seal) in
            _ = oAuthClient.get(url.absoluteString,
                                parameters: parameters,
                                headers: headers,
                                success: { (response) in
                                    do {
                                        seal.fulfill(try self.handleSuccessfulResponse(response))
                                    } catch {
                                        seal.reject(JSONErr.parseFailed(error: error))
                                    }
            }, failure: { (error) in
                _ = seal.reject(error)
            })
        }
    }

    open func authorizedPost<T: Codable>(path: String,
                                         jsonData: Data? = nil,
                                         headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        guard let url = URL(string: path, relativeTo: baseUrl) else {
            return JSONErr.invalidUrl(urlString: path).rejectedPromise()
        }

        return authorizedPost(url: url, jsonData: jsonData, headers: headers)
    }

    open func authorizedPost<T: Codable>(path: String,
                                         object: T,
                                         headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        guard let url = URL(string: path, relativeTo: baseUrl) else {
            return Promise<T>(error: JSONErr.invalidUrl(urlString: path))
        }

        return authorizedPost(url: url, object: object, headers: headers)
    }

    open func authorizedPost<T: Codable>(url: URL,
                                         jsonData: Data? = nil,
                                         headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        guard let oAuthClient = oAuthClient else {
            return JSONErr.unauthorizedAttempt.rejectedPromise()
        }

        return Promise<T> { (seal) in
            _ = oAuthClient.post(url.absoluteString,
                                 parameters: [:],
                                 headers: headers,
                                 body: jsonData,
                                 success: { (response) in
                                    do {
                                        seal.fulfill(try self.handleSuccessfulResponse(response))
                                    } catch {
                                        seal.reject(JSONErr.parseFailed(error: error))
                                    }
            }, failure: { (error) in
                _ = seal.reject(error)
            })
        }
    }

    open func authorizedPost<T: Codable>(url: URL,
                                         object: T,
                                         headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        if oAuthClient == nil {
            return JSONErr.unauthorizedAttempt.rejectedPromise()
        }

        do {
            let data = try JSONUtils.jsonData(forObject: object)
            return authorizedPost(url: url, jsonData: data, headers: headers)
        } catch {
            return Promise<T> { (seal) in
                seal.reject(error)
            }
        }
    }

    // MARK: - Utility functions

    open func handleSuccessfulResponse<T: Codable>(_ response: OAuthSwiftResponse) throws -> T {
        return try handleSuccessfulData(response.data)
    }

}
