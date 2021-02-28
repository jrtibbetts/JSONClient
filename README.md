# JSONClient

## A simple iOS client that `GET`s unauthenticated or authenticated (OAuth) JSON data from and `POST`s authenticated data to a REST service.

Although it's easy enough to use `URLSession`s for unauthenticated calls and authenticated ones using a tool like [`OAuthSwift`](https://github.com/OAuthSwift/OAuthSwift/), this `JSONClient` simplifies those operations and serves as the base class of the clients in my [`SwiftDiscogs`](https://github.com/jrtibbetts/SwiftDiscogs/), [`SwiftMusicbrainz`](https://github.com/jrtibbetts/SwiftMusicbrainz/), and [`SwiftGenius`](https://github.com/jrtibbetts/SwiftGenius/) clients.

See the [Example](./Example.md) page for usage instructions.

## The Details

What language is it? ![Swift 5.3](https://img.shields.io/badge/Swift-5.3-orange.svg)

How can I integrate it into my project? [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Is it licensed? [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

Does it *build*? [![Build Status](https://travis-ci.org/jrtibbetts/JSONClient.svg?branch=main)](https://travis-ci.org/jrtibbetts/JSONClient)

Is it *tested*? [![Codecov](https://codecov.io/gh/jrtibbetts/JSONClient/branch/main/graph/badge.svg)](https://codecov.io/gh/jrtibbetts/JSONClient)

Is it *correct*? [![codebeat badge](https://codebeat.co/badges/6e481297-1745-4a0c-9ac7-70f41fb6ea74)](https://codebeat.co/projects/github-com-jrtibbetts-jsonclient-main)
