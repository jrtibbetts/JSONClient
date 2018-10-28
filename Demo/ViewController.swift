//  Copyright © 2018 Poikile Creations. All rights reserved.

import JSONClient
import OAuthSwift
import PromiseKit
import Stylobate
import UIKit

final class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets

    @IBOutlet weak var errorLabel: UILabel?

    @IBOutlet weak var errorView: UIView?

    @IBOutlet weak var lookUpButton: UIButton?

    @IBOutlet weak var profileTable: UITableView?

    // MARK: Other Properties

    fileprivate var gitHubClient = GitHubClient()

    fileprivate var userInfo: GitHubUser?

    // MARK: Actions

    @IBAction func loadGitHub(sender: UIView?) {
        guard let gitHubClient = gitHubClient else {
            errorLabel?.text = """
Failed to load the GitHub configuration. You must add a file called
'GitHub.plist' that contains your app's consumerKey, consumerSecret,
authorizationUrl, accessTokenUrl, and baseUrl.
"""
            return
        }

        let promise: Promise<OAuthSwiftCredential> = gitHubClient.authorize(presentingViewController: self,
                                                                            callbackUrlString: AppDelegate.callbackUrl.absoluteString,
                                                                            scope: "user")

        promise.then { (credential) -> Promise<GitHubUser> in
            return gitHubClient.authorizedUserData()
            }.done { (userInfo) in
                self.userInfo = userInfo
                self.profileTable?.reloadData()
                self.profileTable?.isHidden = false
            }.catch { (error) in
                self.errorView?.isHidden = false
                self.errorLabel?.text = "Error: \(error.localizedDescription)"
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        errorView?.isHidden = true
        profileTable?.dataSource = self
        profileTable?.delegate = self
    }

}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        cell.textLabel?.text = "User Name"
        cell.detailTextLabel?.text = userInfo?.name

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
