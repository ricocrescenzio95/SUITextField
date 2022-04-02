//
//  SUITextFieldExampleApp.swift
//  SUITextFieldExample
//
//  Created by Rico Crescenzio on 31/03/22.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct SUITextFieldExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class Delegate: NSObject, UIApplicationDelegate {

    func applicationDidFinishLaunching(_ application: UIApplication) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = UIHostingController(rootView: ContentView())
        window!.makeKeyAndVisible()
    }

    var window: UIWindow?

}
