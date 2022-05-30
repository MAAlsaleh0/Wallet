//
//  PasswordGenaretorView.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 24/10/1443 AH.
//

import SwiftUI
import Combine

struct PasswordGenaretorView: View {
    @ObservedObject var VM = PasswordGeneratorVM()
    @State var ShowAlert = false
    @State var alert : Alert?
    var body: some View {
        NavigationView {
            Form {
                Section("details") {
                    Stepper(LocalizedStringKey("Lenght:").toString() + "\(VM.Lenght)", value: $VM.Lenght, in: 0...500)
                    Toggle("Include Numbers:(01234...)", isOn: $VM.isNumbers)
                    Toggle("Include Symbols:(!@#$%^...)", isOn: $VM.isSymbols)
                    Toggle("Include Uppercase Characters:", isOn: $VM.isCharactersUP)
                    Toggle("Include Lowercase Characters:", isOn: $VM.isCharactersL)
                    
                }
                Section("Your New Password:") {
                    Text(VM.PasswordGenerated)
                        .textSelection(.enabled)
                    Button("Copy Password") {
                        UIPasteboard.general.string = VM.PasswordGenerated
                        self.alert = Alert(title: Text("Password copied to clipboard"))
                        self.ShowAlert = true
                    }
                    Button("Generate Password") {
                        VM.GeneratePassword()
                    }.alert(isPresented: $ShowAlert) {
                        alert!
                    }
                }
                
                
            }.onChange(of: VM.Lenght) { _ in
                VM.GeneratePassword()
            }.onChange(of: VM.isNumbers) { _ in
                VM.GeneratePassword()
            }.onChange(of: VM.isSymbols) { _ in
                VM.GeneratePassword()
            }.onChange(of: VM.isCharactersL) { _ in
                VM.GeneratePassword()
            }.onChange(of: VM.isCharactersUP) { _ in
                VM.GeneratePassword()
        }.navigationTitle("Password Generator")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PasswordGenaretorView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGenaretorView()
    }
}

