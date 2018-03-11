//  Copyright © 2018 Poikile Creations. All rights reserved.

import JSONClient
import UIKit

open class GitHubClient: AuthorizedJSONClient.OAuth2 {

    public init() {
        super.init(consumerKey: "ba0597f46e243fa91102",
                   consumerSecret: "4371ba8f91a1dd308e803e2b2e3c748b6ee63fc7",
                   authorizeUrl: "https://github.com/login/oauth/authorize",
                   accessTokenUrl: "https://github.com/login/oauth/access_token")
    }

}
