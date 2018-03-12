//  Copyright © 2018 Poikile Creations. All rights reserved.

import OAuthSwift
import PromiseKit

open class OAuth2: AuthorizedJSONClient {

    fileprivate let oAuth2: OAuth2Swift

    /// A one-time random string value that's added to request headers and
    /// checked against a response's headers to ensure that the call was
    /// made by the right entity.
    fileprivate let state: String = "\(arc4random_uniform(UINT32_MAX))"

    public init(consumerKey: String,
                consumerSecret: String,
                authorizeUrl: String,
                accessTokenUrl: String,
                baseUrl: URL? = nil) {
        oAuth2 = OAuth2Swift(consumerKey: consumerKey,
                             consumerSecret: consumerSecret,
                             authorizeUrl: authorizeUrl,
                             accessTokenUrl: accessTokenUrl,
                             responseType: "token")
        super.init(oAuth: oAuth2, baseUrl: baseUrl)
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
