//
//  DetailsView.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 25/10/1443 AH.
//

import SwiftUI

struct DetailsView: View {
    @State var data : Item
    @Binding var ShowThisView : Bool
    @State var ShowEditView = false
    @State var ShowAlert = false
    @State var alert:Alert?
    @StateObject var coredata : Coredata
    @Environment(\.managedObjectContext) var managedObjContext
    var body: some View {
        List {
            if self.data.ifisPassWord {
                HStack {
                    Text("Name:")
                    Spacer()
                    Text(data.itemName ?? "")
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Username:")
                    Spacer()
                    Text(data.userName ?? "")
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Password:")
                    Spacer()
                    Text(data.password ?? "")
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Last Change:")
                    Spacer()
                    Text(String(DateFormatter.localizedString(from: data.date ?? Date(), dateStyle: .medium, timeStyle: .short)))
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                Button("Copy Username") {
                    UIPasteboard.general.string = data.userName
                    self.alert = Alert(title: Text("Username copied to clipboard"))
                    self.ShowAlert = true
                }
                Button("Copy Password") {
                    UIPasteboard.general.string = data.password
                    self.alert = Alert(title: Text("Password copied to clipboard"))
                    self.ShowAlert = true
                }
                Button("Delete Password"){
                    self.alert = Alert(title: Text("Are you sure?"), message: Text("When you delete it, it can’t be recovered again!"), primaryButton: .destructive(Text("Delete"), action: {
                        self.coredata.removeData(item: data, context: self.managedObjContext)
                        self.ShowThisView = false
                    }), secondaryButton: .cancel())
                    self.ShowAlert = true
                }.foregroundColor(.red).alert(isPresented: $ShowAlert) {
                    alert!
                }
            } else if data.ifIsCredit {
                HStack {
                    Text("Name:")
                    Spacer()
                    Text(data.itemName ?? "")
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Card Number:")
                    Spacer()
                    Text(data.creditNUM ?? "")
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Expiry date:")
                    Spacer()
                    Text(data.creditDate ?? "")
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("CVV Number:")
                    Spacer()
                    Text(data.creditCVC ?? "")
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Last Change:")
                    Spacer()
                    Text(String(DateFormatter.localizedString(from: data.date ?? Date(), dateStyle: .medium, timeStyle: .short)))
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                Button("Copy Card Number") {
                    UIPasteboard.general.string = data.creditNUM
                    self.alert = Alert(title: Text("Card Number copied to clipboard"))
                    self.ShowAlert = true
                }
                Button("Delete Card"){
                    self.alert = Alert(title: Text("Are you sure?"), message: Text("When you delete it, it can’t be recovered again!"), primaryButton: .destructive(Text("Delete"), action: {
                        self.coredata.removeData(item: data, context: self.managedObjContext)
                        self.ShowThisView = false
                    }), secondaryButton: .cancel())
                    self.ShowAlert = true
                }.foregroundColor(.red).alert(isPresented: $ShowAlert) {
                    alert!
                }
            } else if data.ifisOther {
                HStack {
                    Text("Name:")
                    Spacer()
                    Text(data.itemName ?? "")
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Text:")
                    Spacer()
                    Text(data.otherAnyThings!)
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Last Change:")
                    Spacer()
                    Text(String(DateFormatter.localizedString(from: data.date ?? Date(), dateStyle: .medium, timeStyle: .short)))
                        .textSelection(.enabled)
                        .foregroundColor(.secondary)
                }
                Button("Copy Text") {
                    UIPasteboard.general.string = data.password
                    self.alert = Alert(title: Text("Text copied to clipboard"))
                    self.ShowAlert = true
                }
                Button("Delete Text"){
                    self.alert = Alert(title: Text("Are you sure?"), message: Text("When you delete it, it can’t be recovered again!"), primaryButton: .destructive(Text("Delete"), action: {
                        self.coredata.removeData(item: data, context: self.managedObjContext)
                        self.ShowThisView = false
                    }), secondaryButton: .cancel())
                    self.ShowAlert = true
                }.foregroundColor(.red).alert(isPresented: $ShowAlert) {
                    alert!
                }
            }
            
        }.navigationBarItems(trailing: Button("Edit") {self.ShowEditView = true}).navigationTitle(data.itemName ?? "").sheet(isPresented: $ShowEditView) {
            EditView(ShowDetailsView: $ShowThisView, showThisView: $ShowEditView, coredata: coredata, data: data)
        }
    }
}

//struct DetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailsView()
//    }
//}

