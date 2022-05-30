//
//  CreditCardView.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 24/10/1443 AH.
//

import SwiftUI

struct CreditCardView: View {
    @State var itemName = ""
    @State var creditCard = ""
    @State var cvc = ""
    @State var dateM = Int(Calendar.current.component(.month, from: Date()))
    @State var dateY = Int(Calendar.current.component(.year, from: Date()))
    var date : String {
        return "\(dateM.description + " / " + dateY.description)"
    }
    @StateObject var coredata:Coredata
    @Environment(\.colorScheme) var colorsheme
    @Binding var ShowAddView :Bool
    @FocusState var focusState1
    @FocusState var focusState2
    @Environment(\.managedObjectContext) var managedObjContext
    @State var alert:Alert?
    @State var ShowAlert = false
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                HStack {
                    Image(systemName: "lightbulb")
                    TextField("Card for shopping...", text: $itemName)
                }.padding(.horizontal)
            }.padding(.horizontal).frame(height: 40)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                HStack {
                    Image(systemName: "creditcard")
                    TextField("****1234", text: $creditCard)
                        .keyboardType(.asciiCapableNumberPad)
                }.padding(.horizontal)
            }.padding(.horizontal).frame(height: 40)
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                    HStack {
                        Image(systemName: "calendar")
                        Picker("" , selection: $dateM) {
                            ForEach(1..<13,id: \.self) { d in
                                Text(d.description.leadingZeros(2))
                            }
                        }.pickerStyle(MenuPickerStyle())
                        Text("/")
                        Picker("" , selection: $dateY) {
                            ForEach(Int(Calendar.current.component(.year, from: Date())) ..<  (Int(Calendar.current.component(.year, from: Date()) + 20)),id: \.self) { d in
                                Text(d.description)
                            }
                        }.pickerStyle(MenuPickerStyle())
                        
                    }
                }.padding(.horizontal).frame(height: 40)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                    HStack {
                        Image(systemName: "creditcard.and.123")
                        TextField("123", text: $cvc)
                            .keyboardType(.asciiCapableNumberPad)
                    }.padding(.horizontal)
                }.padding(.horizontal).frame(height: 40)
            }
            Button {
                if self.itemName == "" && self.creditCard == "" && self.date == "" && self.cvc == "" || self.itemName == "" || self.creditCard == "" || self.date == "" || self.cvc == "" {
                    alert = Alert(title: Text("Error"), message: Text("You should fill them all."), dismissButton: .default(Text("Okay")))
                    self.ShowAlert = true
                } else {
                    print(date)
                    print(dateY)
                    self.coredata.AddData(creditCVC: self.cvc, creditDate: ("\((dateM.description) + " / " + (dateY.description))"), creditNUM: self.creditCard, ifIsCredit: true, ifisOther: false, ifisPassWord: false, itemName: self.itemName, otherAnyThings: nil, password: nil, userName: nil, Context: managedObjContext)
                self.ShowAddView = false
                }
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor((self.colorsheme == .dark ? .white : .black))
                    .overlay(Text("Save")
                        .foregroundColor(self.colorsheme == .light ? .white : .black))
            }.frame(height: 50).padding()

        }.alert(isPresented: $ShowAlert, content: {
            alert!
        }).padding().onChange(of: self.creditCard) { _ in
            if self.creditCard.count == 20 {
                creditCard.removeLast()
            } else {
                self.creditCard = creditCard.applyPattern()
            }
        }.onChange(of: self.cvc) { _ in
            if self.cvc.count == 4 {
                cvc.removeLast()
            }
        }
//        .onChange(of: dateM) { newValue in
//            if newValue.count == 2 {
//                self.focusState2 = true
//            }
//        }.onChange(of: self.focusState1) { newValue in
//            if !newValue {
//                dateM = dateM.leadingZeros(2)
//            }
//        }
    }
}

//struct CreditCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreditCardView()
//    }
//}

extension String {

    init(withInt int: Int, leadingZeros: Int = 2) {
        self.init(format: "%0\(leadingZeros)d", int)
    }

    func leadingZeros(_ zeros: Int) -> String {
        if let int = Int(self) {
            return String(withInt: int, leadingZeros: zeros)
        }
        print("Warning: \(self) is not an Int")
        return ""
    }
    
}
