//
//  AddInWalletView.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 24/10/1443 AH.
//

import SwiftUI

struct AddInWalletView: View {
    @State var array = [LocalizedStringKey("Password").toString(),LocalizedStringKey("Credit Card").toString(),LocalizedStringKey("Other").toString()]
    @State var selected = LocalizedStringKey("Password").toString()
    @StateObject var coredata:Coredata
    @Binding var ShowAddView :Bool
    var body: some View {
            ScrollView {
                        Picker("", selection: $selected) {
                            ForEach(self.array , id:\.self) { data in
                                Text(data).tag(data)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                    
                if selected == LocalizedStringKey("Credit Card").toString() {
                        CreditCardView(coredata: coredata, ShowAddView: $ShowAddView)
                } else if selected == LocalizedStringKey("Password").toString() {
                        PasswordView(coredata: coredata, ShowAddView: $ShowAddView)
                } else if selected == LocalizedStringKey("Other").toString() {
                        OtherView(coredata: coredata, ShowAddView: $ShowAddView)
                    }
            }.navigationTitle("Add To Wallet")
        
    }
}

struct AddInWalletView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddInWalletView(coredata: Coredata(), ShowAddView: .constant(true))
        }
    }
}
