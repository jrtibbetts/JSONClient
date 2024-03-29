//  Copyright © 2018 Poikile Creations. All rights reserved.

import OAuthSwift
import OAuthSwiftAuthenticationServices
import UIKit

/// An `AuthorizedJSONClient` implementation that uses OAuth 2 for
/// authentication and authorization.
open class OAuth2JSONClient: AuthorizedJSONClient {
    
    /// The OAuth engine. Note that there's already an `oAuth` property in the
    /// superclass, and its type is `OAuthSwift`, which is the superclass of
    /// `OAuth2Swift`. This one is here so that we don't have to cast the
    /// `oAuth` property to the desired type.
    private let oAuth2: OAuth2Swift

    /// Initialize the client with the app's hashes on the server, as well as
    /// the server's various OAuth-related URLs.
    ///
    /// - parameter consumerKey: The hash that identifies the app that this
    ///             client communicates with. It's also called a client key.
    /// - parameter consumerSecret: The password hash for the server app. This
    ///             value should not be included in publicly-visible code.
    /// - parameter authorizeUrl: The URL of the app's sign-in page.
    /// - parameter accessTokenUrl: The URL where the OAuth client can exchange
    ///             a request token for an access token.
    /// - parameter baseUrl: The service's root-level URL. All relative paths
    ///             that are passed to the various REST functions will be
    ///             resolved against this URL. If it's `nil`, then all paths
    ///             must be absolute URL strings.
    public init(consumerKey: String,
                consumerSecret: String,
                authorizeUrl: String,
                accessTokenUrl: String,
                baseUrl: URL? = nil,
                jsonDecoder: JSONDecoder) {
        oAuth2 = OAuth2Swift(consumerKey: consumerKey,
                             consumerSecret: consumerSecret,
                             authorizeUrl: authorizeUrl,
                             accessTokenUrl: accessTokenUrl,
                             responseType: "token")  // will it always be "token"?
        super.init(oAuth: oAuth2, authorizeUrl: authorizeUrl, baseUrl: baseUrl, jsonDecoder: jsonDecoder)
    }

    /// Launch the service's sign-in page in a modal Safari web view. After the
    /// user has successfully authenticated, the web page will be redirected to
    /// the callback URL, which is unique to the client application.
    ///
    /// - parameter callbackUrl: The URL that the web view will load after
    ///             authentication succeeds.
    /// - parameter scope: The level of access that the client is requesting.
    ///             See the server's documentation for what scopes are
    ///             supported. The default value is an empty string.
    ///
    /// - returns:  A `Promise` containing whatever type of data is sent back
    ///             by the server after authentication succeeds.
    open func authorize(callbackUrl: URL,
                        scope: String = "",
                        presentOver view: UIView) async throws -> OAuthSwiftCredential {
        if let credential = oAuthCredential, !credential.isTokenExpired() {
            return credential
        } else {
            oAuth2.authorizeURLHandler = await ASWebAuthenticationSessionURLHandler(callbackUrlScheme: callbackUrl.scheme!,
                                                                                    presentationAnchor: view.window)

            return await withUnsafeContinuation { (continuation) in
                oAuth2.authorize(withCallbackURL: callbackUrl,
                                 scope: scope,
                                 state: state) { (result) in
                    switch result {
                    case .success(let (credential, _, _)):
                        continuation.resume(returning: credential)
                    case .failure:
                        return
                    }
                }
            }
        }
    }

}
