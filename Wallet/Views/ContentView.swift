//
//  ContentView.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 24/10/1443 AH.
//

import SwiftUI

struct ContentView: View {
    @State var text = ""
    @StateObject var coredata:Coredata
    var body: some View {
        
        TabView {
            
        HomeView(coredata: coredata)
                .tabItem {
                    Label("Wallet", systemImage: "person.crop.square.filled.and.at.rectangle")
                }
        PasswordGenaretorView()
                .tabItem {
                    Label("Password Generator", systemImage: "key")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(coredata: Coredata())
    }
}

extension String {
    func applyPattern(pattern: String = "#### #### #### ####", replacmentCharacter: Character = "#") -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
