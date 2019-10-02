//
//  AuthServices.swift
//  VkMessenger
//
//  Created by Илья Тетин on 01/10/2019.
//  Copyright © 2019 Илья Тетин. All rights reserved.
//

import Foundation
import VKSdkFramework

protocol AuthServiceDelegate {
    func authServiceShoudShow(_ viewController: UIViewController)
    func authServiceSignIn()
    func authServiceDidSignInFail()
}

final class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    private let id = "7152741"
    private let vkSdk: VKSdk
    
    var delegate: AuthServiceDelegate?
    override init() {
        vkSdk = VKSdk.initialize(withAppId: id)
        super.init()
        print("VkSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["oflline"]
        
        VKSdk.wakeUpSession(scope) { (state, error) in
            if state == VKAuthorizationState.authorized {
                print("VKAuthorizationState.authorized")
            } else if state == VKAuthorizationState.initialized {
                print("VKAuthorizationState.initialized")
                self.delegate?.authServiceSignIn()
                VKSdk.authorize(scope)
            } else {
                print("ERROR ERROR ERROR ERROR ERROR ERROR")
                self.delegate?.authServiceDidSignInFail()
            }
        }
    }
    
    // MARK: VkSdkDelegate
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        delegate?.authServiceSignIn()
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
    
    // MARK: VkSdkUiDelegate
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShoudShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
