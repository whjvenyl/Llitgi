//
//  PocketAPIConfiguration.swift
//  ReadLater
//
//  Created by Xavi Moll on 25/12/2017.
//  Copyright © 2017 xmollv. All rights reserved.
//

import Foundation

let kAccesToken = "accessToken"

class PocketAPIConfiguration {
    /// This is the API key generated on the Pocket website
    let consumerKey = "73483-2233031e613a5b40f9c466f7"
    
    /// This is the redirect URI that Pocket will redirect once the OAuth
    /// process has finalized
    let redirectUri = "xmollv-readlater://pocketAuth"
    
    /// This is the temporary code used to authorize the app and get an
    /// access token
    var authCode: String?
    
    /// This is the token that must be present on all the authenticated
    /// requests to the Pocket API (alongside with the consumer key)
    var accessToken: String?
    
    init() {
        self.accessToken = UserDefaults.standard.string(forKey: kAccesToken)
    }
}

struct RequestTokenResponse: JSONInitiable {
    let code: String
    
    init?(dict: JSONDictionary) {
        guard let code = dict["code"] as? String else { return nil }
        self.code = code
    }
}

struct AuthorizeTokenResponse: JSONInitiable {
    let accessToken: String
    
    init?(dict: JSONDictionary) {
        guard let accessToken = dict["access_token"] as? String else { return nil }
        self.accessToken = accessToken
    }
}