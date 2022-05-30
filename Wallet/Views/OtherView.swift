//
//  OtherView.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 25/10/1443 AH.
//

import SwiftUI

struct OtherView: View {
    @State var text = ""
    @State var itemName = ""
    @Environment(\.colorScheme) var colorsheme
    @StateObject var coredata:Coredata
    @Binding var ShowAddView :Bool
    @State var alert : Alert?
    @State var ShowAlert = false
    @Environment(\.managedObjectContext) var managedObjContext
    var body: some View {
        ZStack {
            Color.clear.frame(maxWidth:.infinity,maxHeight: .infinity)
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                    HStack {
                        Image(systemName: "lightbulb")
                        TextField("school note..", text: $itemName)
                    }.padding(.horizontal)
                }.padding(.horizontal).frame(height: 40)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                    HStack {
                        VStack {
                            Image(systemName: "note")
                                .padding(.top,15)
                            Spacer()
                        }
                        ZStack(alignment:.leading) {
                            if text == "" {
                                
                                TextEditor(text:.constant(LocalizedStringKey("Type anything you want to store in the wallet.").toString()))
                                    .font(.body)
                                    .foregroundColor(Color(UIColor.placeholderText))
                                    .disabled(true)
                                    .padding(.top,6)
                                
                            }
                            TextEditor(text: $text)
                                .opacity(self.text == "" ? 0.25 : 1)
                                .padding(.top,6)
                            
                        }.frame(alignment:.top)
                    }.padding(.horizontal)
                }.padding(.horizontal).frame(height: 150)
                Button {
                    if self.itemName == "" || self.text == "" || self.itemName == "" && self.text == "" {
                        alert = Alert(title: Text("Error"), message: Text("You should fill them all."), dismissButton: .default(Text("Okay")))
                        self.ShowAlert = true
                    } else {
                    self.coredata.AddData(creditCVC: nil, creditDate: nil, creditNUM: nil, ifIsCredit: false, ifisOther: true, ifisPassWord: false, itemName: self.itemName, otherAnyThings: self.text, password: nil, userName: nil, Context: managedObjContext)
                    self.ShowAddView = false
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor((self.colorsheme == .dark ? .white : .black))
                        .overlay(Text("Save")
                            .foregroundColor(self.colorsheme == .light ? .white : .black))
                }.frame(height: 50).padding()
            }.padding().onTapGesture {
                UIApplication.shared.endEditing()
            }
            
        }.alert(isPresented: $ShowAlert) {
            alert!
        }
        
    }
}

//struct OtherView_Previews: PreviewProvider {
//    static var previews: some View {
//        OtherView()
//    }
//}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
