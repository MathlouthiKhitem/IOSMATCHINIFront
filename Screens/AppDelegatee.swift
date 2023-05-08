//
//  AppDelegatee.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 7/5/2023.
//

import Foundation
import SwiftUI
import Stripe
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        StripeAPI.defaultPublishableKey = "pk_test_51N5FRxLwcHojLkgQOQIVis89z6aWgYHrcXZM8uWaOdvqFVpcEO56YgNFMbzUJMOAeZXQtbpP1ZzgXIF6U59deqr400w3jA2Zec"
        return true
    }
    
}
