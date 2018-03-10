//  Copyright © 2018 Poikile Creations. All rights reserved.

import JSONClient
import PromiseKit
import UIKit

final class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet weak var outputLabel: UILabel?

    @IBOutlet weak var searchButton: UIButton?

    // MARK: Other Properties

    fileprivate var jsonClient = JSONClient()

    // MARK: Actions
    @IBAction func load(sender: UIView?) {
        let promise: Promise<DiscogsInfo> = jsonClient.get(path: "https://api.discogs.com/")

        promise.then { (discogsInfo) -> Void in
            if var text = self.outputLabel?.text {
                text = "Discogs Information\n"
                text.append("\(discogsInfo.hello)\n")
                text.append("API Version: \(discogsInfo.api_version)\n")
                text.append("Artist count: \(discogsInfo.statistics.artists)\n")
                text.append("Release count: \(discogsInfo.statistics.releases)\n")
                text.append("Label count: \(discogsInfo.statistics.labels)\n")
                self.outputLabel?.text = text
            }
            }.catch { (error) in
                self.outputLabel?.text = error.localizedDescription
                self.urlField?.text = ""
        }
    }

}
