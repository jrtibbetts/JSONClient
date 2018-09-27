//  Copyright © 2018 Poikile Creations. All rights reserved.

import JSONClient
import OAuthSwift
import PromiseKit
import UIKit

final class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var lookUpButton: UIButton?

    @IBOutlet weak var outputLabel: UILabel?

    @IBOutlet weak var userNameField: UITextField?

    // MARK: Other Properties

    fileprivate var gitHubClient = GitHubClient()

    // MARK: Actions

    @IBAction func loadGitHub(sender: UIView?) {
        guard let userName = userNameField?.text else {
            outputLabel?.text = "Enter a GitHub username and try again."
            return
        }

        guard let gitHubClient = gitHubClient else {
            outputLabel?.text = """
Failed to load the GitHub configuration. You must add a file called
'GitHub.plist' that contains your app's consumerKey, consumerSecret,
authorizationUrl, accessTokenUrl, and baseUrl.
"""
            return
        }

        let promise: Promise<OAuthSwiftCredential> = gitHubClient.authorize(presentingViewController: self,
                                                                            callbackUrlString: AppDelegate.callbackUrl.absoluteString)

        promise.then { (credential) -> Promise<GitHubUser> in
            return gitHubClient.userData(for: userName)
            }.done { (userInfo) in
                self.outputLabel?.text = userInfo.name
            }.catch { (error) in
                self.outputLabel?.text = "Error: \(error.localizedDescription)"
        }
    }

}
