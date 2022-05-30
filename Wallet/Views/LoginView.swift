//
//  LoginView.swift
//  Wallet
//
//  Created by Mohammed Alsaleh on 24/10/1443 AH.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @StateObject var coredata:Coredata
    @Binding var passcode :String
    @State var buttons = [
        ["1","2","3"],
        ["4","5","6"],
        ["7","8","9"],
        ["f","0","X"]
    ]
    @State var passcodeT1 = ""
    @State var Verifypasscode = ""
    @State var isVerifyMode = false
    @State var massge = "Enter your new passcode"
    @State var error = ""
    @State var passcodeLogin = ""
    @State var isUnlocked = false
    @State var attempts = 0
    var blur : Bool {
        return (self.scenePhase == .background || self.scenePhase == .inactive)
    }
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorsheme
    var body: some View {
        if passcode == "" {
            // SignUp
            NavigationView {
                VStack {
                    VStack {
                        Text(self.isVerifyMode ? "Verify your new passcode" : "Enter your new passcode")
                        HStack(spacing: 15.0) {
                            ForEach(1..<5) { i in
                                if i <= (!isVerifyMode ? passcodeT1.count : Verifypasscode.count) {
                                    Circle()
                                        .frame(height: 50)
                                } else {
                                    Circle()
                                        .stroke()
                                        .frame(height: 50)
                                }
                            }
                        }.frame(width: 140)
                        Text(LocalizedStringKey(error))
                    }.frame(maxHeight:.infinity,alignment:.center)
                    Spacer()
                    VStack(spacing: 8) {
                        ForEach(buttons , id:\.self) { data in
                            HStack(spacing: 8) {
                                ForEach(data , id:\.self) { d in
                                    Button {
                                        if d == "X" {
                                            if isVerifyMode {
                                                if Verifypasscode.count != 0 {
                                                    Verifypasscode.removeLast()
                                                }
                                            } else {
                                                if passcodeT1.count != 0 {
                                                    passcodeT1.removeLast()
                                                }
                                            }
                                        } else if d == "f" {
                                            
                                        } else {
                                            if isVerifyMode {
                                                if Verifypasscode.count != 4 {
                                                    self.Verifypasscode += d
                                                }
                                            } else {
                                                if passcodeT1.count != 4 {
                                                    self.passcodeT1 += d
                                                }
                                            }
                                        }
                                    } label: {
                                        ZStack {
                                            if d != "X" && d != "f" {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke((colorsheme == .light ? .black.opacity(0.7) : .white.opacity(0.7)))
                                            }
                                            if d == "X" {
                                                Image(systemName: "delete.backward")
                                                    .font(.system(size: 35))
                                                    .frame(height:70)
                                                    .frame(maxWidth:.infinity)
                                                    .foregroundColor(self.colorsheme == .dark ? .white : .black)
                                            } else if d == "f" {
                                                
                                            } else {
                                                Text(d)
                                                    .font(.system(size: 35))
                                                    .frame(height:70)
                                                    .frame(maxWidth:.infinity)
                                                    .foregroundColor(self.colorsheme == .dark ? .white : .black)
                                            }
                                        }.frame(height:70)
                                            .frame(maxWidth:.infinity)
                                    }
                                }
                            }
                        }.environment(\.layoutDirection, .leftToRight)
                    }.padding(.horizontal).onChange(of: self.passcodeT1) { z in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            if passcodeT1.count == 4 {
                                self.isVerifyMode = true
                            }
                        }
                    }.onChange(of: self.Verifypasscode) { v in
                        if self.Verifypasscode.count == 4 {
                            if self.passcodeT1 == v {
                                self.passcode = Verifypasscode
                                print(passcode)
                                print(true)
                            } else {
                                self.isVerifyMode = false
                                self.passcodeT1 = ""
                                self.Verifypasscode = ""
                                self.error = "Passcodes did not match. Try again."
                            }
                        }
                    }
                }.navigationTitle("Set New Passcode").navigationBarItems(leading: Button(action: {
                    self.isVerifyMode = false
                    self.passcodeT1 = ""
                    self.Verifypasscode = ""
                }, label: {
                    Text(isVerifyMode ? "Back" : "")
                }))
            }.navigationViewStyle(StackNavigationViewStyle())
            
        } else if isUnlocked {
            ZStack {
                ContentView(coredata: coredata)
                    .onAppear(perform: {
                        AppReviewRequest.requestReviewIfNeeded()
                    })
                if self.scenePhase == .background || self.scenePhase == .inactive {
                    Rectangle().fill(.thinMaterial).ignoresSafeArea()
                }
            }
        } else {
            // LogIn
            NavigationView {
                VStack {
                    VStack {
                        Text("Enter Your Passcode.")
                        HStack(spacing: 15.0) {
                            ForEach(1..<5) { i in
                                if i <= passcodeLogin.count {
                                    Circle()
                                        .frame(height: 50)
                                } else {
                                    Circle()
                                        .stroke()
                                        .frame(height: 50)
                                }
                            }
                        }.frame(width: 140).modifier(Shake(animatableData: CGFloat(attempts)))
                        if error != "" {
                            Text(LocalizedStringKey(error))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .background(Color.red.cornerRadius(5))
                        }
                    }.frame(maxHeight:.infinity,alignment:.center)
                    Spacer()
                    VStack(spacing: 8) {
                        ForEach(buttons , id:\.self) { data in
                            HStack(spacing: 8) {
                                ForEach(data , id:\.self) { d in
                                    Button {
                                        if d == "X" {
                                            if passcodeLogin.count != 0 {
                                                passcodeLogin.removeLast()
                                            }
                                        } else if d == "f" {
                                            let context = LAContext()
                                            var error: NSError?
                                            
                                            // check whether biometric authentication is possible
                                            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                                                // it's possible, so go ahead and use it
                                                let reason = "We need to unlock your data."
                                                
                                                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                                                    // authentication has now completed
                                                    if success {
                                                        // authenticated successfully
                                                        self.isUnlocked = true
                                                    } else {
                                                        // there was a problem
                                                        print("problem")
                                                    }
                                                }
                                            } else {
                                                // no biometrics
                                                
                                            }
                                        } else {
                                            
                                            if passcodeLogin.count != 4 {
                                                self.passcodeLogin += d
                                            }
                                        }
                                    } label: {
                                        ZStack {
                                            if d != "X" && d != "f" {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke((colorsheme == .light ? .black.opacity(0.7) : .white.opacity(0.7)))
                                            }
                                            if d == "X" {
                                                Image(systemName: "delete.backward")
                                                    .font(.system(size: 35))
                                                    .frame(height:70)
                                                    .frame(maxWidth:.infinity)
                                                    .foregroundColor(self.colorsheme == .dark ? .white : .black)
                                            } else if d == "f" {
                                                Image(systemName: "faceid")
                                                    .font(.system(size: 35))
                                                    .frame(height:70)
                                                    .frame(maxWidth:.infinity)
                                                    .foregroundColor(self.colorsheme == .dark ? .white : .black)
                                            } else {
                                                Text(d)
                                                    .font(.system(size: 35))
                                                    .frame(height:70)
                                                    .frame(maxWidth:.infinity)
                                                    .foregroundColor(self.colorsheme == .dark ? .white : .black)
                                            }
                                        }.frame(height:70)
                                            .frame(maxWidth:.infinity)
                                    }
                                }
                            }
                            
                        }.environment(\.layoutDirection, .leftToRight).padding(.horizontal)
                    }.navigationTitle("Login")
                }.onChange(of: self.passcodeLogin) { v in
                    if v.count == 4 {
                        if v == self.passcode {
                            print(true)
                            self.isUnlocked = true
                        } else {
                            withAnimation(.default) {
                                attempts += 1
                            }
                            self.passcodeLogin.removeAll()
                            self.error = "Failed Passcode"
                            print("ee")
                        }
                    }
                }.onAppear {
                    let context = LAContext()
                    let reason = "We need to unlock your data."
                    
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                        // authentication has now completed
                        if success {
                            // authenticated successfully
                            self.isUnlocked = true
                        } else {
                            // there was a problem
                            print("problem")
                        }
                    }
                }
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(passcode: .constant(""))
//            .preferredColorScheme(.dark)
//    }
//}



struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}
