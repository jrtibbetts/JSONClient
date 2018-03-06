# JSONClient
[![Build Status](https://travis-ci.org/jrtibbetts/JSONClient.svg?branch=master)](https://travis-ci.org/jrtibbetts/JSONClient)
## A simple iOS client that `GET`s unauthenticated or authenticated (OAuth) JSON data from and `POST`s authenticated data to a REST service.

Although it's easy enough to use `URLSession`s for unauthenticated calls and authenticated ones using a tool like [`OAuthSwift`](https://github.com/OAuthSwift/OAuthSwift/), this `JSONClient` simplifies those operations and serves as the base class of the clients in my [`SwiftDiscogs`](https://github.com/jrtibbetts/SwiftDiscogs/), [`SwiftMusicbrainz`](https://github.com/jrtibbetts/SwiftMusicbrainz/), and [`SwiftGenius`](https://github.com/jrtibbetts/SwiftGenius/) clients.
