//
//  ProfileView.swift
//  SwiftUI Advanced
//
//  Created by Damien Gautier on 27/03/2023.
//

import SwiftUI
import RevenueCat

struct ProfileView: View {
    
    @State private var showLoader: Bool = false
    @State private var iapButtonTitle = "Purchase Lifetime Pro Plan"
    
    var body: some View {
        ZStack {
            Image("background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("pink-gradient-1"))
                                .frame(width: 66, height: 66, alignment: .center)
                            
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 25, weight: .medium, design: .rounded))
                        }
                        .frame(width: 66, height: 66, alignment: .center)
                        
                        VStack(alignment: .leading) {
                            Text("Damien")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("View profile")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            print("Segue to settings")
                        }, label: {
                            TextfieldIcon(iconName: "gearshape.fill", currentlyEditing: .constant(true))
                        })
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    Text("Instructor at Design+Code")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Label("Awarded 10 certificates since September 2020", systemImage: "calendar")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.footnote)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    HStack(spacing: 16) {
                        Image("Twitter")
                            .resizable()
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 24, height: 24, alignment: .center)
                        
                        Image(systemName: "link")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        
                        Text("designcode.io")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.footnote)
                    }
                }
                .padding(16)
                
                GradientButton(buttonTitle: iapButtonTitle) {
                    showLoader = true
                    Purchases.shared.getOfferings { offerings, error in
                        if let packages = offerings?.current?.availablePackages {
                            Purchases.shared.purchase(package: packages.first!) { transaction, purchaserInfo, error, userCancelled in
                                print("TRANSACTION: \(transaction)")
                                print("PURCHASER INFO: \(purchaserInfo)")
                                print("ERROR: \(error)")
                                print("USER CANCELLED: \(userCancelled)")
                                
                                if purchaserInfo?.entitlements["pro"]?.isActive == true {
                                    showLoader = false
                                    iapButtonTitle = "Purchase Successful"
                                } else {
                                    showLoader = false
                                    iapButtonTitle = "Purchase Failed"
                                }
                            }
                        } else {
                            showLoader = false
                        }
                        
                    }
                }
                .padding(.horizontal, 16)
                
                Button(action: {
                    showLoader = true
                    Purchases.shared.restorePurchases { purchaserInfo, error in
                        if let info = purchaserInfo {
                            if info.allPurchasedProductIdentifiers.contains("lifetime_pro_plan") {
                                iapButtonTitle = "Restore Successful"
                                showLoader = false
                            } else {
                                showLoader = false
                                iapButtonTitle = "No purchases Found"
                            }
                        } else {
                            showLoader = false
                            iapButtonTitle = "Restore Failed"
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
                    print("Sign out")
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
        .preferredColorScheme(.dark)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
