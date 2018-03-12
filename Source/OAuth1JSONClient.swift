//  Copyright © 2018 Poikile Creations. All rights reserved.

import OAuthSwift
import PromiseKit
import UIKit

open class OAuth1JSONClient: AuthorizedJSONClient {

    fileprivate let oAuth1: OAuth1Swift

    public init(consumerKey: String,
                consumerSecret: String,
                requestTokenUrl: String,
                authorizeUrl: String,
                accessTokenUrl: String,
                baseUrl: URL? = nil) {
        oAuth1 = OAuth1Swift(consumerKey: consumerKey,
                             consumerSecret: consumerSecret,
                             requestTokenUrl: requestTokenUrl,
                             authorizeUrl: authorizeUrl,
                             accessTokenUrl: accessTokenUrl)
        super.init(oAuth: oAuth1, baseUrl: baseUrl)
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

