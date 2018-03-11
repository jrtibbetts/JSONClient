//  Copyright © 2018 Poikile Creations. All rights reserved.

import OAuthSwift
import PromiseKit
import UIKit

open class AuthorizedJSONClient: JSONClient {

    open class OAuth1: AuthorizedJSONClient {

        fileprivate let oAuth1: OAuth1Swift

        public init(consumerKey: String,
                    consumerSecret: String,
                    requestTokenUrl: String,
                    authorizeUrl: String,
                    accessTokenUrl: String) {
            oAuth1 = OAuth1Swift(consumerKey: consumerKey,
                                 consumerSecret: consumerSecret,
                                 requestTokenUrl: requestTokenUrl,
                                 authorizeUrl: authorizeUrl,
                                 accessTokenUrl: accessTokenUrl)
            super.init(oAuth: oAuth1)
        }

        open func authorize<T>(presentingViewController: UIViewController,
                               callbackUrlString: String) -> Promise<T> {
            oAuth1.authorizeURLHandler = SafariURLHandler(viewController: presentingViewController, oauthSwift: oAuth)

            return Promise<T>() { (fulfill, reject) in
                _ = self.oAuth1.authorize(withCallbackURL: callbackUrlString,
                                          success: { [weak self] (credentials, response, parameters) in
                                            self?.oAuthClient = OAuthSwiftClient(credential: credentials)
                    }, failure: { (error) in
                        reject(error)
                })
            }
        }

    }

    open class OAuth2: AuthorizedJSONClient {

        fileprivate let oAuth2: OAuth2Swift

        /// A one-time random string value that's added to request headers and
        /// checked against a response's headers to ensure that the call was
        /// made by the right entity.
        fileprivate let state: String = "\(arc4random_uniform(UINT32_MAX))"

        public init(consumerKey: String,
                    consumerSecret: String,
                    authorizeUrl: String) {
            oAuth2 = OAuth2Swift(consumerKey: consumerKey,
                                 consumerSecret: consumerSecret,
                                 authorizeUrl: authorizeUrl,
                                 responseType: "token")
            super.init(oAuth: oAuth2)
        }

        open func authorize<T>(presentingViewController: UIViewController,
                               callbackUrlString: String,
                               scope: String = "") -> Promise<T> {
            oAuth2.authorizeURLHandler = SafariURLHandler(viewController: presentingViewController, oauthSwift: oAuth)

            return Promise<T>() { (fulfill, reject) in
                _ = self.oAuth2.authorize(withCallbackURL: callbackUrlString,
                                          scope: scope,
                                          state: state,
                                          success: { [weak self] (credentials, response, parameters) in
                                            self?.oAuthClient = OAuthSwiftClient(credential: credentials)
                    }, failure: { (error) in
                        reject(error)
                })
            }
        }

    }

    // MARK: - Properties

    /// The client that handles OAuth authorization and inserts the relevant
    /// headers in calls to the server. Subclasses should assign a value to
    /// this once the user successfully authenticates with the server.
    var oAuthClient: OAuthSwiftClient?

    var oAuth: OAuthSwift

    // MARK: - Initialization

    public init(oAuth: OAuthSwift,
                baseUrl: URL? = nil) {
        self.oAuth = oAuth
        super.init(baseUrl: baseUrl)
    }

    // MARK: - REST methods

    open func authorizedGet<T: Codable>(path: String,
                                        headers: Headers = [:],
                                        params: [String: Any] = [:]) -> Promise<T> {
        let url = URL(string: path, relativeTo: baseUrl)

        return authorizedGet(url: url, headers: headers, params: params)
    }

    open func authorizedGet<T: Codable>(url: URL?,
                                        headers: Headers = [:],
                                        params: [String: Any] = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            guard let absoluteUrl = url?.absoluteString else {
                reject(JSONErr.invalidUrl(urlString: url?.relativeString ?? "nil URL"))
                return
            }

            let _ = oAuthClient?.get(absoluteUrl,
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
            let _ = oAuthClient?.post(url.absoluteString,
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

    open func authenticatedPost<T: Codable>(url: URL,
                                            object: T,
                                            headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            do {
                let data = try JSONUtils.jsonData(forObject: object)

                let _ = oAuthClient?.post(url.absoluteString,
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
