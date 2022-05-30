//
//  PasswordGeneratorVM.swift
//  The Wallet | المحفظة
//
//  Created by Mohammed Alsaleh on 29/10/1443 AH.
//

import Combine

class PasswordGeneratorVM : ObservableObject {
    @Published var PasswordGenerated = ""
    @Published var Lenght = 8
    @Published var isSymbols = true
    @Published var isNumbers = true
    @Published var isCharactersL = true
    @Published var isCharactersUP = true
    let symbols = "!@#$%^&*()_+-=}{|?><"
    let numbers = "1234567890"
    let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    init() {
        self.GeneratePassword()
    }
    
    func GeneratePassword() {
        var pass = ""
        if isSymbols {
            pass += symbols
        }
        if isNumbers {
            pass += numbers
        }
        if isCharactersL {
            pass += characters.lowercased()
        }
        if isCharactersUP {
            pass += characters
        }
        self.PasswordGenerated = String((0..<Lenght).map{ _ in pass.randomElement() ?? Character(" ") })
    }
    
}
