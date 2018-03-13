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
                                        headers: Headers = [:],
                                        params: [String: Any] = [:]) -> Promise<T> {
        guard let url = URL(string: path, relativeTo: baseUrl) else {
            return Promise<T>() { (_, reject) in
                reject(JSONErr.invalidUrl(urlString: path))
            }
        }

        return authorizedGet(url: url, headers: headers, params: params)
    }

    open func authorizedGet<T: Codable>(url: URL,
                                        headers: Headers = [:],
                                        params: [String: Any] = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            guard let oAuthClient = oAuthClient else {
                reject(JSONErr.unauthorizedAttempt)
                return
            }

            let _ = oAuthClient.get(url.absoluteString,
                                    parameters: params,
                                    headers: headers,
                                    success: { (response) in
                                        do {
                                            fulfill(try self.handleSuccessfulResponse(response))
                                        } catch {
                                            reject(JSONErr.parseFailed(error: error))
                                        }
            }, failure: { (error) in
                reject(error)
            })
        }
    }

    open func authorizedPost<T: Codable>(url: URL,
                                         headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            guard let oAuthClient = oAuthClient else {
                reject(JSONErr.unauthorizedAttempt)
                return
            }

            let _ = oAuthClient.post(url.absoluteString,
                                     parameters: [:],
                                     headers: headers,
                                     success: { (response) in
                                        do {
                                            fulfill(try self.handleSuccessfulResponse(response))
                                        } catch {
                                            reject(JSONErr.parseFailed(error: error))
                                        }
            }, failure: { (error) in
                reject(error)
            })
        }
    }

    open func authorizedPost<T: Codable>(url: URL,
                                         object: T,
                                         headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            guard let oAuthClient = oAuthClient else {
                reject(JSONErr.unauthorizedAttempt)
                return
            }

            do {
                let data = try JSONUtils.jsonData(forObject: object)

                let _ = oAuthClient.post(url.absoluteString,
                                         parameters: [:],
                                         headers: headers,
                                         body: data,
                                         success: { (response) in
                                            do {
                                                fulfill(try self.handleSuccessfulResponse(response))
                                            } catch {
                                                reject(JSONErr.parseFailed(error: error))
                                            }
                }, failure: { (error) in
                    reject(error)
                })
            } catch {
                reject(error)
            }
        }
    }

    // MARK: - Utility functions

    open func handleSuccessfulResponse<T: Codable>(_ response: OAuthSwiftResponse) throws -> T {
        return try handleSuccessfulData(response.data)
    }

}
