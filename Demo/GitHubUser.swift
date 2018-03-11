//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct GitHubUser: Codable {
    public var login: String
    public var id: Int
    public var avatar_url: String
    public var gravatar_id: String
    public var url: String
    public var html_url: String
    public var followers_url: String
    public var following_url: String
    public var gists_url: String
    public var starred_url: String
    public var subscriptions_url: String
    public var organizations_url: String
    public var repos_url: String
    public var events_url: String
    public var received_events_url: String
    public var type: String
    public var site_admin: Bool
    public var name: String
    public var company: String
    public var blog: URL
    public var location: String
    public var email: String
    public var hireable: Bool
    public var bio: String
    public var public_repos: Int
    public var public_gists: Int
    public var followers: Int
    public var following: Int
    public var created_at: String
    public var updated_at: String
    public var total_private_repos: Int
    public var owned_private_repos: Int
    public var private_gists: Int
    public var disk_usage: Int
    public var collaborators: Int
    public var two_factor_authentication: Bool
    public var plan: Plan

    public struct Plan: Codable {
        public var name: String
        public var space: Int
        public var private_repos: Int
        public var collaborators: Int
    }
}
