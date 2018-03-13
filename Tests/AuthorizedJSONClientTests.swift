//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import JSONClient
import OAuthSwift
import PromiseKit
import XCTest

class AuthorizedJSONClientTests: JSONClientTests {
    
    override func validJSONClient(baseUrl: URL? = nil) -> JSONClient {
        let oAuth = OAuth1Swift(consumerKey: "foo", consumerSecret: "bar")
        
        return AuthorizedJSONClient(oAuth: oAuth, baseUrl: baseUrl)
    }

    func testAuthorizedGetBeforeAuthorizationFails() {
        let client = validJSONClient() as! AuthorizedJSONClient
        let url = URL(string: "https://api.discogs.com")!
        let promise: Promise<DiscogsInfo> = client.authorizedGet(url: url)
        let errorMessage = "The call should have been rejected because the user isn't authorized"

        assert(promise: promise,
               wasUnauthorizedWithMessage: errorMessage)
    }

    func testAuthorizedPostBeforeAuthorizationFails() {
        let client = validJSONClient() as! AuthorizedJSONClient
        let url = URL(string: "https://api.discogs.com")!
        let promise: Promise<DiscogsInfo> = client.authorizedPost(url: url)
        let errorMessage = "The call should have been rejected because the user isn't authorized"

        assert(promise: promise,
               wasUnauthorizedWithMessage: errorMessage)
    }

    func testAuthorizedPostWithDataBeforeAuthorizationFails() {
        let client = validJSONClient() as! AuthorizedJSONClient
        let url = URL(string: "https://api.discogs.com")!
        let string = "This is the payload to be posted."
        let promise: Promise<String> = client.authorizedPost(url: url, object: string)
        let errorMessage = "The call should have been rejected because the user isn't authorized"

        assert(promise: promise,
               wasUnauthorizedWithMessage: errorMessage)
    }

    func assert<T: Codable>(promise: Promise<T>,
                            wasUnauthorizedWithMessage errorMessage: String) {
        let exp = expectation(description: errorMessage)

        promise.then { (obj) -> Void in
            XCTFail(errorMessage)
            }.catch { (error) in
                guard let error = error as? JSONClient.JSONErr else {
                    XCTFail(errorMessage)
                    return
                }

                switch error {
                case .unauthorizedAttempt:
                    exp.fulfill()
                default:
                    XCTFail(errorMessage)
                }
        }

        wait(for: [exp], timeout: 5.0)
    }

}

class OAuth1JSONClientTests: AuthorizedJSONClientTests {

    override func validJSONClient(baseUrl: URL? = nil) -> JSONClient {
        return OAuth1JSONClient(consumerKey: "foo",
                                consumerSecret: "bar",
                                requestTokenUrl: "one",
                                authorizeUrl: "two",
                                accessTokenUrl: "three",
                                baseUrl: baseUrl)
    }

}

class OAuth2JSONClientTests: AuthorizedJSONClientTests {

    override func validJSONClient(baseUrl: URL? = nil) -> JSONClient {
        return OAuth2JSONClient(consumerKey: "foo",
                                consumerSecret: "bar",
                                authorizeUrl: "one",
                                accessTokenUrl: "two",
                                baseUrl: baseUrl)
    }

}
