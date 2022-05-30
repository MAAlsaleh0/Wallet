//
//  EditView.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 25/10/1443 AH.
//

import SwiftUI

struct EditView: View {
    @Environment(\.colorScheme) var colorsheme
    @State var itemName = ""
    @State var Username = ""
    @State var Password = ""
    @State var sequre = true
    @State var creditCard = ""
    @State var cvc = ""
    @State var dateM = Int(Calendar.current.component(.month, from: Date()))
    @State var dateY = Int(Calendar.current.component(.year, from: Date()))
    @State var alert : Alert?
    @State var ShowAlert = false
    var date : String {
        return "\(dateM.description + " / " + dateY.description)"
    }
    @State var text = ""
    @FocusState var focusState1
    @FocusState var focusState2
    @Binding var ShowDetailsView : Bool
    @Binding var showThisView : Bool
    @StateObject var coredata:Coredata
    @Environment(\.managedObjectContext) var managedObjContext
    @State var data : Item
    var body: some View {
        NavigationView {
            if data.ifisPassWord {
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
                        self.coredata.UpdateData(item: self.data, creditCVC: nil, creditDate: nil, creditNUM: nil, ifIsCredit: false, ifisOther: false, ifisPassWord: true, itemName: self.itemName, otherAnyThings: nil, password: self.Password, userName: self.Username, Context: managedObjContext)
                        self.ShowDetailsView = false
                        self.showThisView = false
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor((self.colorsheme == .dark ? .white : .black))
                            .overlay(Text("Edit")
                                .foregroundColor(self.colorsheme == .light ? .white : .black))
                    }.frame(height: 50).padding()
                }.alert(isPresented: $ShowAlert, content: {
                    alert!
                }).padding().onAppear {
                    self.itemName = data.itemName!
                    self.Username = data.userName!
                    self.Password = data.password!
                }
            } else if data.ifIsCredit {
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
                                Picker("",selection: $dateM) {
                                    ForEach(1..<13,id: \.self) {
                                        Text($0.description.leadingZeros(2))
                                    }
                                }
                                Text("/")
                                Picker("",selection: $dateY) {
                                    ForEach(Int(Calendar.current.component(.year, from: Date())) ..<  (Int(Calendar.current.component(.year, from: Date()) + 20)),id: \.self) {
                                        Text($0.description)
                                    }
                                }
                                
                            }                        }.padding(.horizontal).frame(height: 40)
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
                        self.coredata.UpdateData(item:data,creditCVC: self.cvc, creditDate: self.date, creditNUM: self.creditCard, ifIsCredit: true, ifisOther: false, ifisPassWord: false, itemName: self.itemName, otherAnyThings: nil, password: nil, userName: nil, Context: managedObjContext)
                        self.showThisView = false
                        self.ShowDetailsView = false
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor((self.colorsheme == .dark ? .white : .black))
                            .overlay(Text("Edit")
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
                }.onAppear {
                    self.itemName = data.itemName!
                    self.creditCard = data.creditNUM!
                    self.cvc = data.creditCVC!
                    self.dateM = Int(self.data.creditDate!.prefix(2))!
                    self.dateY = Int(self.data.creditDate!.dropFirst(5))!
                }
            } else if data.ifisOther {
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
                            self.coredata.UpdateData(item:data,creditCVC: nil, creditDate: nil, creditNUM: nil, ifIsCredit: false, ifisOther: true, ifisPassWord: false, itemName: self.itemName, otherAnyThings: self.text, password: nil, userName: nil, Context: managedObjContext)
                            self.showThisView = false
                            self.ShowDetailsView = false
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor((self.colorsheme == .dark ? .white : .black))
                                .overlay(Text("Edit")
                                    .foregroundColor(self.colorsheme == .light ? .white : .black))
                        }.frame(height: 50).padding()
                    }.padding().onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    
                }.alert(isPresented: $ShowAlert, content: {
                    alert!
                }).onAppear {
                    self.itemName = self.data.itemName!
                    self.text = self.data.otherAnyThings!
                }
            }
        }
    }
}
