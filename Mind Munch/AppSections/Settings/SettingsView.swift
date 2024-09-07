//
//  SettingsView.swift
//  Mind Munch
//
//  Created by Arthur GUERIN on 07/09/2024.
//

import SwiftUI

// MARK: - Settings Template / Few stuff pending

struct SettingsView: View {
    @State private var appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
//    @State private var lastOpened = getLastOpened() // Call your method to get the last opened timestamp
//    @State private var userID = getUserID()
//    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingShareSheet = false
    let appDownloadLink = "https://apps.apple.com/app/id6670610058" // Replace with your actual App Store link
    let helpURL = URL(string: "https://www.gto.wtf")!
    
    @State private var isIAP = false
    //@StateObject private var store = Store()

    @State private var isPro = false

    var body: some View {
        NavigationView {
            ZStack {
                OverallBackground().edgesIgnoringSafeArea(.all)
                List {
                    Section(header: Text("General")) {
                        NavigationLink(destination: ChangeIcon()) {
                            Image(systemName: "app.badge.fill")
                            Text("App Icon")
                        }
//                        NavigationLink(destination: NotificationsParams()) {
//                            Image(systemName: "bell.badge")
//                            Text("Notification")
//                        }
//                        NavigationLink(destination: ChangeLanguage()) {
//                            Image(systemName: "flag.badge.ellipsis.fill")
//                            Text("Language")
//                        }
                    }
                    
                    
                    Section(header: Text("Other")) {
                        Button(action: openAppStoreForReview) {
                            HStack {
                                Image(systemName: "star.bubble")
                                Text("Leave Us a Review")
                                Spacer()
                            }
                        }
                        Button(action: {
                            self.showingShareSheet = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share App")
                                Spacer()
                            }
                        }
                        .sheet(isPresented: $showingShareSheet) {
                            ShareSheet(activityItems: [URL(string: appDownloadLink)!])
                        }
                        Link(destination: helpURL) {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                Text("Help")
                                Spacer()
                            }
                        }
                    }
                    
                    Section(header: Text("Official")) {
                        HStack {
                            Image(systemName: "checkmark.shield")
                            Link("Privacy Policy", destination: URL(string: "https://www.https://www.gto.wtf/privacy")!)
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "book.pages")
                            Link("Terms & Conditions", destination: URL(string: "https://www.gto.wtf/terms")!)
                            Spacer()
                        }
                    }
                    VStack {
                        HStack {
                            Image(systemName: "number.square")
                            Text("Version \(appVersion)")
//                            Spacer()
//                            Image(systemName: "clock.arrow.2.circlepath")
////                            Text("Last Open: \(lastOpened)")
                            Spacer()
                            Button(action: {
                                UIPasteboard.general.string = "Version \(appVersion)"
                            }) {
                                Image(systemName: "doc.on.doc")
                            }
                            .padding(5)
                            .foregroundColor(Color.blue)
                        }
                        .padding(5)
//                        HStack {
//                            Image(systemName: "person.badge.key")
//                            Text("User ID: \(userID)")
//                            Spacer()
//                        }
                        .padding(.top, 5)
                    }
                    .padding(5)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                }
                .foregroundColor(.white)
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Profile", displayMode: .large)
                .navigationBarItems(
                    leading: Button("Dismiss") {
                        presentationMode.wrappedValue.dismiss()
                    })
                .background(
                    OverallBackground().edgesIgnoringSafeArea(.all)
                )
            }
        }
        .padding()
        .presentationDragIndicator(.visible)
        .onAppear {
//            self.lastOpened = getLastOpened()
//            self.userID = getUserID()
    }

    }
    func openAppStoreForReview() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id6670610058?action=write-review")
        else { return }
        
        if UIApplication.shared.canOpenURL(writeReviewURL) {
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct GeneralSettingsView: View {
    var body: some View {
        Text("Settings")
    }
}

#Preview {
    SettingsView()
}
