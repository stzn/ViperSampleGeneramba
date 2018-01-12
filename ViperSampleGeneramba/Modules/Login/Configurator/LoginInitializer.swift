//
//  LoginLoginInitializer.swift
//  ViperSampleGeneramba
//
//  Created by stakata on 01/01/2018.
//  Copyright © 2018 officekoma. All rights reserved.
//

import UIKit

class LoginModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var loginViewController: LoginViewController!

    override func awakeFromNib() {

        let configurator = LoginModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: loginViewController)
    }

}
