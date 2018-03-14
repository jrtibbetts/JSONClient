//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct GitHubUser: Codable {
    public var avatarUrl: String
    public var bio: String
    public var blog: URL
    public var collaborators: Int
    public var company: String
    public var createdAt: String
    public var diskUsage: Int
    public var email: String
    public var eventsUrl: String
    public var followers: Int
    public var following: Int
    public var followersUrl: String
    public var followingUrl: String
    public var gistsUrl: String
    public var gravatarId: String
    public var hireable: Bool
    public var htmlUrl: String
    public var id: Int
    public var location: String
    public var login: String
    public var name: String
    public var organizationsUrl: String
    public var ownedPrivateRepos: Int
    public var plan: Plan
    public var privateGists: Int
    public var publicGists: Int
    public var publicRepos: Int
    public var receivedEventsUrl: String
    public var reposUrl: String
    public var siteAdmin: Bool
    public var starredUrl: String
    public var subscriptionsUrl: String
    public var totalPrivateRepos: Int
    public var twoFactorAuthentication: Bool
    public var type: String
    public var url: String
    public var updatedAt: String

    fileprivate enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case bio
        case blog
        case collaborators
        case company
        case createdAt = "created_at"
        case diskUsage = "disk_usage"
        case email
        case eventsUrl = "events_url"
        case followers
        case following
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case gravatarId = "gravatar_id"
        case hireable
        case htmlUrl = "html_url"
        case id
        case location
        case login
        case name
        case organizationsUrl = "organizations_url"
        case ownedPrivateRepos = "owned_private_repos"
        case plan
        case privateGists = "private_gists"
        case publicGists = "public_gists"
        case publicRepos = "public_repos"
        case receivedEventsUrl = "received_events_url"
        case reposUrl = "repos_url"
        case siteAdmin = "site_admin"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case totalPrivateRepos = "total_private_repos"
        case twoFactorAuthentication = "two_factor_authentication"
        case type
        case url
        case updatedAt = "updated_at"
    }

    public struct Plan: Codable {
        public var collaborators: Int
        public var name: String
        public var private_repos: Int
        public var space: Int
   }
}
