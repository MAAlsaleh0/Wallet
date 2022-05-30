//
//  HomeView.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 25/10/1443 AH.
//

import SwiftUI

struct HomeView: View {
    @StateObject var coredata:Coredata
    @State var data = [Item]()
    @State var ShowAddView = false
    @State var ShowDetailsViewP = false
    @State var ShowDetailsViewC = false
    @State var ShowDetailsViewO = false
    @State var sequre = false
    @State var d : Item?
    @Environment(\.colorScheme) var colorShceme
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    if self.data.count != 0 {
                        if data.filter({$0.ifisPassWord}).count != 0 {
                            Section("Passwords") {
                                ForEach(data) { d in
                                    if d.ifisPassWord {
                                        Button {
                                            self.d = d
                                            self.ShowDetailsViewP = true
                                        } label: {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Image(systemName: "lightbulb")
                                                    Text(d.itemName!)
                                                }
                                                HStack {
                                                    Image(systemName: "calendar")
                                                    Text(String(DateFormatter.localizedString(from: d.date!, dateStyle: .medium, timeStyle: .short)))
                                                }
                                            }.frame(maxWidth:.infinity,alignment:.leading).padding().foregroundColor(colorShceme == .light ? .black : .white)
                                        }                                    }
                                }.background(NavigationLink("", isActive:$ShowDetailsViewP) {
                                    if self.d != nil {
                                        DetailsView(data: d!, ShowThisView: $ShowDetailsViewP, coredata: coredata)
                                    }
                                })
                            }
                        }
                        if data.filter({$0.ifIsCredit}).count != 0 {
                            Section("Credit Cards") {
                                ForEach(data) { d in
                                    if d.ifIsCredit {
                                        Button {
                                            self.d = d
                                            self.ShowDetailsViewC = true
                                        } label: {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Image(systemName: "lightbulb")
                                                    Text(d.itemName!)
                                                }
                                                HStack {
                                                    Image(systemName: "calendar")
                                                    Text(String(DateFormatter.localizedString(from: d.date!, dateStyle: .medium, timeStyle: .short)))
                                                }
                                                HStack {
                                                    Image(systemName: "creditcard")
                                                    Text("****" + String(d.creditNUM!.suffix(4)))
                                                }
                                            }.frame(maxWidth:.infinity,alignment:.leading).padding().foregroundColor(colorShceme == .light ? .black : .white)
                                        }
                                        
                                    }
                                }.background(NavigationLink("", isActive:$ShowDetailsViewC) {
                                    if self.d != nil {
                                        DetailsView(data: d!, ShowThisView: $ShowDetailsViewC, coredata: coredata)
                                    }
                                })
                                
                            }
                            
                        }
                        if data.filter({$0.ifisOther}).count != 0 {
                            Section("Others") {
                                ForEach(data) { d in
                                    if d.ifisOther {
                                        Button {
                                            self.d = d
                                            self.ShowDetailsViewO = true
                                        } label: {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Image(systemName: "lightbulb")
                                                    Text(d.itemName!)
                                                }
                                                HStack {
                                                    Image(systemName: "calendar")
                                                    Text(String(DateFormatter.localizedString(from: d.date!, dateStyle: .medium, timeStyle: .short)))
                                                }
                                                HStack {
                                                    Image(systemName: "note")
                                                    Text(d.otherAnyThings!)
                                                }
                                            }.frame(maxWidth:.infinity,alignment:.leading).padding().foregroundColor(colorShceme == .light ? .black : .white)
                                        }
                                    }
                                }.background(NavigationLink("", isActive:$ShowDetailsViewO) {
                                    if self.d != nil {
                                        DetailsView(data: d!, ShowThisView: $ShowDetailsViewO, coredata: coredata)
                                    }
                                })
                                
                            }
                            
                        }
                        
                    } else {
                        Text("You don't have anything in the wallet")
                    }
                }
            }.background(NavigationLink("", isActive: $ShowAddView, destination: {
                AddInWalletView(coredata: coredata, ShowAddView: $ShowAddView)
            })).navigationBarItems(trailing: Button(action: {
                self.ShowAddView = true
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.title2)
            })).navigationTitle("Wallet")
            
            
        }.onAppear(perform: {
            data.removeAll()
            data = self.coredata.getData()
        }).onChange(of: self.ShowDetailsViewP, perform: { _ in
            data.removeAll()
            data = self.coredata.getData()
        })
        .onChange(of: self.ShowDetailsViewO, perform: { _ in
            data.removeAll()
            data = self.coredata.getData()
        })
        .onChange(of: self.ShowDetailsViewC, perform: { _ in
            data.removeAll()
            data = self.coredata.getData()
        }).onChange(of: self.ShowAddView, perform: { _ in
            data.removeAll()
            data = self.coredata.getData()
        }).navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(coredata: Coredata())
    }
}
