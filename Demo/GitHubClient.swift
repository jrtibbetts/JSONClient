//  Copyright © 2018 Poikile Creations. All rights reserved.

import JSONClient
import Foundation
import PromiseKit
import UIKit

open class GitHubClient: OAuth2JSONClient {

    public init?() {
        let bundle = Bundle(for: GitHubClient.self)

        guard let path = bundle.path(forResource: "GitHub", ofType: "plist"),
            let props = NSDictionary(contentsOfFile: path),
            let consumerKey = props.object(forKey: "consumerKey") as? String,
            let consumerSecret = props.object(forKey: "consumerSecret") as? String,
            let authorizeUrl = props.object(forKey: "authorizeUrl") as? String,
            let accessTokenUrl = props.object(forKey: "accessTokenUrl") as? String,
            let baseUrlString = props.object(forKey: "baseUrl") as? String,
            let baseUrl = URL(string: baseUrlString) else {
            return nil
        }

        super.init(consumerKey: consumerKey,
                   consumerSecret: consumerSecret,
                   authorizeUrl: authorizeUrl,
                   accessTokenUrl: accessTokenUrl,
                   baseUrl: baseUrl)
    }

    open func authorizedUserData() -> Promise<GitHubUser> {
        return authorizedGet(path: "user")
    }

    open func userData(for userName: String) -> Promise<GitHubUser> {
        return get(path: "users/\(userName)")
    }

}
