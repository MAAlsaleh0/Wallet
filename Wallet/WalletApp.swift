//
//  WalletApp.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 24/10/1443 AH.
//

import SwiftUI

@main
struct WalletApp: App {
    @AppStorage("passcode") var passcode = ""
    @StateObject var coredata = Coredata()
    var body: some Scene {
        WindowGroup {
            LoginView(coredata: coredata, passcode: $passcode)
                .environment(\.managedObjectContext, coredata.container.viewContext)
        }
    }
}
