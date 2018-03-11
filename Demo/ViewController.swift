//  Copyright © 2018 Poikile Creations. All rights reserved.

import JSONClient
import PromiseKit
import UIKit

final class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet weak var outputLabel: UILabel?

    @IBOutlet weak var signInButton: UIButton?

    // MARK: Other Properties

    fileprivate var gitHubClient = GitHubClient()

    // MARK: Actions

    @IBAction func loadGitHub(sender: UIView?) {
        let promise: Promise<GitHubUser> = gitHubClient.authorize(presentingViewController: self,
                                             callbackUrlString: AppDelegate.callbackUrlString)
        promise.then { (user) -> Void in
            self.outputLabel?.text = user.name
            }.catch { (error) in
                self.outputLabel?.text = "Error: \(error.localizedDescription)"
        }
    }

}
