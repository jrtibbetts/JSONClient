//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsInfo: Codable {
    public var apiVersion: String
    public var documentationUrl: URL
    public var hello: String
    public var statistics: Stats

    fileprivate enum CodingKeys: String, CodingKey {
        case apiVersion = "api_version"
        case documentationUrl = "documentation_url"
        case hello
        case statistics
    }

    public struct Stats: Codable {
        public var labels: Int
        public var artists: Int
        public var releases: Int
    }
}
