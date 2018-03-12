//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import JSONClient
import OAuthSwift
import XCTest

class AuthorizedJSONClientTests: JSONClientTests {
    
    override func validJSONClient(baseUrl: URL?) -> JSONClient {
        let oAuth = OAuth1Swift(consumerKey: "foo", consumerSecret: "bar")
        
        return AuthorizedJSONClient(oAuth: oAuth, baseUrl: baseUrl)
    }

}

class OAuth1JSONClientTests: JSONClientTests {

    override func validJSONClient(baseUrl: URL?) -> JSONClient {
        return OAuth1JSONClient(consumerKey: "foo",
                                consumerSecret: "bar",
                                requestTokenUrl: "one",
                                authorizeUrl: "two",
                                accessTokenUrl: "three",
                                baseUrl: baseUrl)
    }

}

class OAuth2JSONClientTests: JSONClientTests {

    override func validJSONClient(baseUrl: URL?) -> JSONClient {
        return OAuth2JSONClient(consumerKey: "foo",
                                consumerSecret: "bar",
                                authorizeUrl: "one",
                                accessTokenUrl: "two",
                                baseUrl: baseUrl)
    }

}
