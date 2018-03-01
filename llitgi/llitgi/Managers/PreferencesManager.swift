//
//  PreferencesManager.swift
//  llitgi
//
//  Created by Xavi Moll on 12/01/2018.
//  Copyright © 2018 xmollv. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

enum SafariOpener: String {
    case safariViewController
    case safari
}

protocol BadgeDelegate: class {
    func displayBadgeEnabled()
}

protocol PreferencesManager: class {
    var openLinksWith: SafariOpener { get set }
    var openReaderMode: Bool { get set }
    
    weak var badgeDelegate: BadgeDelegate? { get set }
    var userHasEnabledNotifications: Bool { get set }
    func enableBadge(shouldEnable: Bool, then: @escaping (Bool)->())
    func displayBadge(with: Int)
}

class UserPreferencesManager: PreferencesManager {
    
    weak var badgeDelegate: BadgeDelegate? = nil
    
    var userHasEnabledNotifications: Bool {
        get { return LlitgiUserDefaults.shared.bool(forKey: kEnabledNotifications) }
        set {
            LlitgiUserDefaults.shared.set(newValue, forKey: kEnabledNotifications)
            if newValue == true {
                self.badgeDelegate?.displayBadgeEnabled()
            }
        }
    }
    
    var openLinksWith: SafariOpener {
        get {
            let savedValue = LlitgiUserDefaults.shared.string(forKey: kSafariOpener) ?? ""
            return SafariOpener(rawValue: savedValue) ?? .safariViewController
        }
        set { LlitgiUserDefaults.shared.set(newValue.rawValue, forKey: kSafariOpener) }
    }
    
    var openReaderMode: Bool {
        get {
            let savedValue = LlitgiUserDefaults.shared.bool(forKey: kReaderMode)
            return savedValue
        }
        set { LlitgiUserDefaults.shared.set(newValue, forKey: kReaderMode) }
    }
    
    func enableBadge(shouldEnable: Bool, then: @escaping (Bool) -> ()) {
        if shouldEnable {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge], completionHandler: { (granted, error) in
                DispatchQueue.main.async {
                    self.userHasEnabledNotifications = granted
                    then(granted)
                }
            })
        } else {
            DispatchQueue.main.async {
                self.userHasEnabledNotifications = false
                UIApplication.shared.applicationIconBadgeNumber = 0
                then(false)
            }
        }
    }
    
    func displayBadge(with numberOfElements: Int) {
        if self.userHasEnabledNotifications {
            UIApplication.shared.applicationIconBadgeNumber = numberOfElements
        }
    }
    
}
