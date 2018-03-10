//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct DiscogsInfo: Codable {
    public var documentation_url: URL
    public var hello: String
    public var api_version: String
    public var statistics: Stats

    public struct Stats: Codable {
        public var labels: Int
        public var artists: Int
        public var releases: Int
    }
}
