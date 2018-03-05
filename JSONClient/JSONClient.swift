//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation
import OAuthSwift
import PromiseKit

/// A REST client that uses OAuth authentication and gets and posts JSON data.
open class JSONClient: NSObject {

    public enum JSONError: Error {
        case invalidUrl(urlString: String?)
        case nilData
        case parseFailed(error: Error)
    }

    // MARK: - Properties

    /// The root URL for server requests.
    public let baseUrl: URL?
    
    /// The client that handles OAuth authorization and inserts the relevant
    /// headers in calls to the server. Subclasses should assign a value to
    /// this once the user successfully authenticates with the server.
    open var oAuthClient: OAuthSwiftClient?

    open var urlSession: URLSession
    
    // MARK: - Initializers
    
    public init(baseUrl: URL?) {
        self.baseUrl = baseUrl
        self.urlSession = URLSession(configuration: .default)
        super.init()
    }
    
    // MARK: - REST methods

    public func get<T: Codable>(path: String,
                                headers: [String: String] = [:],
                                params: [String: Any] = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            guard let url = URL(string: path, relativeTo: baseUrl) else {
                reject(JSONError.invalidUrl(urlString: path))
                return
            }

            urlSession.dataTask(with: url) { (data, urlResponse, error) in
                if let error = error {
                    reject(error)
                } else {
                    do {
                        guard let data = data else {
                            reject(JSONError.nilData)
                            return
                        }
                        fulfill(try self.handleSuccessfulData(data))
                    } catch {
                        reject(JSONError.parseFailed(error: error))
                    }
                }
            }.resume()
        }
    }

    public func authenticatedGet<T: Codable>(path: String,
                                             headers: OAuthSwift.Headers = [:],
                                             pageNumber: Int = 1,
                                             resultsPerPage: Int = 50) -> Promise<T> {
        let url = URL(string: path, relativeTo: baseUrl)
        return authenticatedGet(url: url,
                                headers: headers,
                                pageNumber: pageNumber,
                                resultsPerPage: resultsPerPage)
    }

    public func authenticatedGet<T: Codable>(url: URL?,
                                             headers: OAuthSwift.Headers = [:],
                                             pageNumber: Int = 1,
                                             resultsPerPage: Int = 50) -> Promise<T> {
        let parameters: OAuthSwift.Parameters
        
        if pageNumber == 0 {
            parameters = [:]
        } else {
            parameters = ["page" : String(pageNumber), "per_page" : String(resultsPerPage)]
        }

        return Promise<T>() { (fulfill, reject) in
            guard let absoluteUrl = url?.absoluteString else {
                reject(JSONError.invalidUrl(urlString: url?.relativeString ?? "nil URL"))
                return
            }

            let _ = oAuthClient?.get(absoluteUrl,
                                     parameters: parameters,
                                     headers: headers,
                                     success: { (response) in
                                        do {
                                            fulfill(try self.handleSuccessfulResponse(response: response))
                                        } catch {
                                            reject(JSONError.parseFailed(error: error))
                                        }
            }, failure: { (error) in
                reject(error)
            })
        }
    }
    
    public func authenticatedPost<T: Codable>(url: URL,
                                 headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            let _ = oAuthClient?.post(url.absoluteString,
                                      parameters: [:],
                                      headers: headers,
                                      success: { (response) in
                                        do {
                                            fulfill(try self.handleSuccessfulResponse(response: response))
                                        } catch {
                                            reject(JSONError.parseFailed(error: error))
                                        }
            }, failure: { (error) in
                reject(error)
            })
        }
    }
    
    public func authenticatedPost<T: Codable>(url: URL,
                                 object: T,
                                 headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            do {
                let data = try JSONUtils.jsonData(forObject: object)
                
                let _ = oAuthClient?.post(url.absoluteString,
                                          parameters: [:],
                                          headers: headers,
                                          body: data,
                                          success: { (response) in
                                            do {
                                                fulfill(try self.handleSuccessfulResponse(response: response))
                                            } catch {
                                                reject(JSONError.parseFailed(error: error))
                                            }
                }, failure: { (error) in
                    reject(error)
                })
            } catch {
                reject(error)
            }
        }
    }
    
    public func handleSuccessfulResponse<T: Codable>(response: OAuthSwiftResponse) throws -> T {
        return try handleSuccessfulData(response.data)
    }

    public func handleSuccessfulData<T: Codable>(_ data: Data) throws -> T {
        return try JSONUtils.jsonObject(data: data)
    }
    
}
