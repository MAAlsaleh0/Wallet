//
//  PasswordView.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 24/10/1443 AH.
//

import SwiftUI

struct PasswordView: View {
    @Environment(\.colorScheme) var colorsheme
    @State var itemName = ""
    @State var Username = ""
    @State var Password = ""
    @State var alert : Alert?
    @State var ShowAlert = false
    @State var sequre = true
    @StateObject var coredata:Coredata
    @Environment(\.managedObjectContext) var managedObjContext
    @Binding var ShowAddView :Bool
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                HStack {
                    Image(systemName: "lightbulb")
                    TextField("Twitter password...", text: $itemName)
                }.padding(.horizontal)
            }.padding(.horizontal).frame(height: 40)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                HStack {
                    Image(systemName: "person")
                    TextField("@Hello", text: $Username)
                }.padding(.horizontal)
            }.padding(.horizontal).frame(height: 40)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                HStack {
                    Image(systemName: "key")
                    if self.sequre {
                        SecureField("XXXXXXXX", text: $Password)
                    } else {
                    TextField("XXXXXXXX", text: $Password)
                    }
                    Button {
                        withAnimation(.spring()) {
                            self.sequre.toggle()
                        }
                        
                    } label: {
                        Image(systemName: self.sequre ? "eye.slash" : "eye")
                    }
                }.padding(.horizontal)
            }.padding(.horizontal).frame(height: 40)
            
            Button {
                if self.itemName == "" || self.Username == "" || self.Password == "" || self.itemName == "" && self.Username == "" && self.Password == "" {
                    alert = Alert(title: Text("Error"), message: Text("You should fill them all."), dismissButton: .default(Text("Okay")))
                    self.ShowAlert = true
                } else {
                self.coredata.AddData(creditCVC: nil, creditDate: nil, creditNUM: nil, ifIsCredit: false, ifisOther: false, ifisPassWord: true, itemName: self.itemName, otherAnyThings: nil, password: self.Password, userName: self.Username, Context: managedObjContext)
                self.ShowAddView = false
                }
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor((self.colorsheme == .dark ? .white : .black))
                    .overlay(Text("Save")
                        .foregroundColor(self.colorsheme == .light ? .white : .black))
            }.frame(height: 50).padding()
        }.padding().alert(isPresented: $ShowAlert) {
            alert!
        }
    }
}

//struct PasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasswordView()
//    }
//}
