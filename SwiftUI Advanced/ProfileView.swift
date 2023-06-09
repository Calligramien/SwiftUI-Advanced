//
//  ProfileView.swift
//  SwiftUI Advanced
//
//  Created by Damien Gautier on 27/03/2023.
//

import SwiftUI
import RevenueCat
import FirebaseAuth
import CoreData

struct ProfileView: View {
    
    @State private var showLoader: Bool = false
    @State private var iapButtonTitle = "Purchase Lifetime Pro Plan"
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlertView: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showSettingsView: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)],
                  predicate: NSPredicate(format: "userID == %@", Auth.auth().currentUser!.uid), animation: .default) private var savedAccounts: FetchedResults<Account>
    @State private var currentAccount: Account?
    
    @State private var updater: Bool = true
    
    var body: some View {
        ZStack {
            Image("background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        if currentAccount?.profileImage != nil {
                            GradientProfilePictureView(profilePicture: UIImage(data: currentAccount!.profileImage!)!)
                                .frame(width: 66, height: 66)
                        } else {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("pink-gradient-1"))
                                    .frame(width: 66, height: 66, alignment: .center)
                                
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25, weight: .medium, design: .rounded))
                            }
                            .frame(width: 66, height: 66, alignment: .center)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(currentAccount?.name ?? "No Name")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("View profile")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showSettingsView.toggle()
                        }, label: {
                            TextfieldIcon(iconName: "gearshape.fill", currentlyEditing: .constant(true), passedImage: .constant(nil))
                        })
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    Text(currentAccount?.bio ?? "No Bio")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if currentAccount?.numberOfCertificates != 0 {
                        Label("Awarded \(currentAccount?.numberOfCertificates ?? 0) certificates since \(dateFormatter(currentAccount?.userSince ?? Date()))", systemImage: "calendar")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.footnote)
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    HStack(spacing: 16) {
                        if currentAccount?.twitterHandle != nil {
                            Image("Twitter")
                                .resizable()
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 24, height: 24, alignment: .center)
                        }
                        
                        if currentAccount?.website != nil {
                            Image(systemName: "link")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                        
                        Text(currentAccount?.website ?? "No website")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.footnote)
                    }
                }
                .padding(16)
                
                GradientButton(buttonTitle: iapButtonTitle) {
                    if currentAccount?.proMember != true {
                        showLoader = true
                        Purchases.shared.getOfferings { offerings, error in
                            if let packages = offerings?.current?.availablePackages {
                                Purchases.shared.purchase(package: packages.first!) { transaction, purchaserInfo, error, userCancelled in
                                    print("TRANSACTION: \(String(describing: transaction))")
                                    print("PURCHASER INFO: \(String(describing: purchaserInfo))")
                                    print("ERROR: \(String(describing: error))")
                                    print("USER CANCELLED: \(userCancelled)")
                                    
                                    if purchaserInfo?.entitlements["pro"]?.isActive == true {
                                        
                                        currentAccount?.proMember = true
                                        iapButtonTitle = "You are a Pro Member"
                                        
                                        do {
                                            try viewContext.save()
                                            
                                            showLoader = false
                                            alertTitle = "Purchase Successful"
                                            alertMessage = "You are now a Pro Member"
                                            showAlertView.toggle()
                                        } catch let error {
                                            alertTitle = "Uh-Oh!"
                                            alertMessage = error.localizedDescription
                                            showAlertView.toggle()
                                            showLoader = false
                                        }
                                        
                                    } else {
                                        showLoader = false
                                        alertTitle = "Purchase Failed"
                                        alertMessage = "You are not a Pro Member"
                                        showAlertView.toggle()
                                    }
                                }
                            } else {
                                showLoader = false
                            }
                            
                        }
                    } else {
                        alertTitle = "No Purchase Necessary"
                        alertMessage = "You are already a Pro Member"
                        showAlertView.toggle()
                    }
                }
                .padding(.horizontal, 16)
                
                Button(action: {
                    showLoader = true
                    Purchases.shared.restorePurchases { purchaserInfo, error in
                        if let info = purchaserInfo {
                            if info.allPurchasedProductIdentifiers.contains("lifetime_pro_plan") {
                                
                                currentAccount?.proMember = true
                                do {
                                    try viewContext.save()
                                    
                                    iapButtonTitle = "You are a Pro Member"
                                    alertTitle = "Restore Success"
                                    alertMessage = "Your purchase has been restored and you are a Pro Member"
                                    showAlertView.toggle()
                                    showLoader = false
                                } catch let error {
                                    alertTitle = "Restore Unsuccesful"
                                    alertMessage = error.localizedDescription
                                    showAlertView.toggle()
                                    showLoader = false
                                }
                                
                            } else {
                                showLoader = false
                                alertTitle = "No purchases Found"
                                alertMessage = "Your purchase has not been restored and you are not a Pro Member"
                                showAlertView.toggle()
                            }
                        } else {
                            showLoader = false
                            alertTitle = "Restore Failed"
                            alertMessage = "Your purchase has not been restored and you are not a Pro Member"
                            showAlertView.toggle()
                        }
                        
                    }
                }, label: {
                    GradientText(text: "Restore Purchases")
                        .font(.footnote)
                        .fontWeight(.bold)
                })
                .padding(.bottom)
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .dark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            )
            .cornerRadius(30)
            .padding(.horizontal)
            
            VStack {
                Spacer()
                
                Button(action: {
                    signout()
                }, label: {
                    Image(systemName: "arrow.turn.up.forward.iphone.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .rotation3DEffect(
                            Angle(degrees: 180), axis: (x: 0.0, y: 0.0, z: 1.0)
                        )
                        .background(
                            Circle()
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                                .frame(width: 42, height: 42, alignment: .center)
                                .overlay(
                                    VisualEffectBlur(blurStyle: .dark)
                                        .cornerRadius(21)
                                        .frame(width: 42, height: 42, alignment: .center)
                                )
                        )
                })
            }
            .padding(.bottom, 64)
            
            if showLoader {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .preferredColorScheme(updater ? .dark : .dark)
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel())
        }
        .sheet(isPresented: $showSettingsView, content: {
            SettingsView()
                .environment(\.managedObjectContext, self.viewContext)
                .onDisappear() {
                    currentAccount = savedAccounts.first!
                    updater.toggle()
                }
        })
        .onAppear() {
            currentAccount = savedAccounts.first
            
            if currentAccount == nil {
                let userDataToSave = Account(context: viewContext)
                userDataToSave.name = Auth.auth().currentUser!.displayName
                userDataToSave.bio = nil
                userDataToSave.userID = Auth.auth().currentUser!.uid
                userDataToSave.numberOfCertificates = 0
                userDataToSave.proMember = false
                userDataToSave.twitterHandle = nil
                userDataToSave.website = nil
                userDataToSave.profileImage = nil
                userDataToSave.userSince = Date()
                do {
                    try viewContext.save()
                } catch let error {
                    alertTitle = "Could not create an account"
                    alertMessage = error.localizedDescription
                    showAlertView.toggle()
                }
            }
            
            if currentAccount?.proMember == false {
                Purchases.shared.getOfferings { offerings, error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    if let allOfferings = offerings, let lifetimePurchase = allOfferings.current?.lifetime {
                        iapButtonTitle = "Purchase Lifetime Pro Plan - \(lifetimePurchase.localizedPriceString)"
                    }
                }
            } else {
                iapButtonTitle = "You are a Pro Member"
            }
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
            dismiss()
        } catch let error {
            alertTitle = "Uh-Oh!"
            alertMessage = error.localizedDescription
            showAlertView.toggle()
        }
    }
    
    func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyy"
        return formatter.string(from: date)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
