//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Prathmesh on 12/10/23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("enableNotifications") private var enableNotifications = true
    @AppStorage("autoRefresh") private var autoRefresh = true
    @AppStorage("refreshInterval") private var refreshInterval = 30.0
    @AppStorage("selectedCurrency") private var selectedCurrency = "USD"
    @AppStorage("showPortfolioValue") private var showPortfolioValue = true
    @AppStorage("enableHaptics") private var enableHaptics = true
    @AppStorage("enableFaceID") private var enableFaceID = false
    
    @Environment(\.dismiss) private var dismiss
    
    let currencies = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD"]
    let refreshIntervals = [15.0, 30.0, 60.0, 300.0]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // User Profile Section
                    profileSection
                    
                    // App Preferences
                    preferencesSection
                    
                    // Security & Privacy
                    securitySection
                    
                    // Data & Sync
                    dataSection
                    
                    // About & Support
                    aboutSection
                    
                    // App Information
                    appInfoSection
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Settings Sections
extension SettingsView {
    
    private var profileSection: some View {
        VStack(spacing: 16) {
            // Profile Image and Info
            VStack(spacing: 12) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                VStack(spacing: 4) {
                    Text("Crypto Investor")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Premium Member")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.background)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    private var preferencesSection: some View {
        SettingsSection(title: "Preferences", icon: "slider.horizontal.3") {
            SettingsToggleRow(
                title: "Dark Mode",
                subtitle: "Use dark appearance",
                icon: "moon.fill",
                isOn: $isDarkMode
            )
            
            SettingsPickerRow(
                title: "Currency",
                subtitle: "Display currency",
                icon: "dollarsign.circle.fill",
                selection: $selectedCurrency,
                options: currencies
            )
            
            SettingsToggleRow(
                title: "Auto Refresh",
                subtitle: "Automatically update prices",
                icon: "arrow.clockwise",
                isOn: $autoRefresh
            )
            
            if autoRefresh {
                SettingsSliderRow(
                    title: "Refresh Interval",
                    subtitle: "\(Int(refreshInterval)) seconds",
                    icon: "timer",
                    value: $refreshInterval,
                    range: 15...300
                )
            }
        }
    }
    
    private var securitySection: some View {
        SettingsSection(title: "Security & Privacy", icon: "lock.shield") {
            SettingsToggleRow(
                title: "Face ID / Touch ID",
                subtitle: "Secure app with biometrics",
                icon: "faceid",
                isOn: $enableFaceID
            )
            
            SettingsToggleRow(
                title: "Show Portfolio Value",
                subtitle: "Display total portfolio worth",
                icon: "eye.fill",
                isOn: $showPortfolioValue
            )
            
            SettingsNavigationRow(
                title: "Privacy Policy",
                subtitle: "View our privacy policy",
                icon: "hand.raised.fill"
            ) {
                // Handle privacy policy navigation
            }
        }
    }
    
    private var dataSection: some View {
        SettingsSection(title: "Data & Notifications", icon: "bell.badge") {
            SettingsToggleRow(
                title: "Push Notifications",
                subtitle: "Price alerts and updates",
                icon: "bell.fill",
                isOn: $enableNotifications
            )
            
            SettingsToggleRow(
                title: "Haptic Feedback",
                subtitle: "Vibrate on interactions",
                icon: "iphone.radiowaves.left.and.right",
                isOn: $enableHaptics
            )
            
            SettingsNavigationRow(
                title: "Export Data",
                subtitle: "Download your portfolio data",
                icon: "square.and.arrow.up"
            ) {
                // Handle data export
            }
            
            SettingsNavigationRow(
                title: "Clear Cache",
                subtitle: "Free up storage space",
                icon: "trash",
                isDestructive: true
            ) {
                // Handle cache clearing
            }
        }
    }
    
    private var aboutSection: some View {
        SettingsSection(title: "About & Support", icon: "questionmark.circle") {
            SettingsNavigationRow(
                title: "Help Center",
                subtitle: "Get help and support",
                icon: "questionmark.circle.fill"
            ) {
                // Handle help center navigation
            }
            
            SettingsNavigationRow(
                title: "Contact Us",
                subtitle: "Send feedback or report issues",
                icon: "envelope.fill"
            ) {
                // Handle contact navigation
            }
            
            SettingsNavigationRow(
                title: "Rate App",
                subtitle: "Rate us on the App Store",
                icon: "star.fill"
            ) {
                // Handle app rating
            }
            
            SettingsNavigationRow(
                title: "Share App",
                subtitle: "Tell your friends about us",
                icon: "square.and.arrow.up"
            ) {
                // Handle app sharing
            }
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            // App Logo and Name
            VStack(spacing: 8) {
                Image("logo") // Your app logo
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text("SwiftfulCrypto")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Version 2.1.0 (Build 42)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Credits and Links
            VStack(spacing: 12) {
                Text("Made with ❤️ using SwiftUI")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 20) {
                    Link(destination: URL(string: "https://www.youtube.com/c/swiftfulthinking")!) {
                        Label("YouTube", systemImage: "play.rectangle.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    Link(destination: URL(string: "https://www.buymeacoffee.com/nicksarno")!) {
                        Label("Coffee", systemImage: "cup.and.saucer.fill")
                            .font(.caption)
                            .foregroundColor(.brown)
                    }
                    
                    Link(destination: URL(string: "https://www.coingecko.com")!) {
                        Label("API", systemImage: "link")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            
            // Legal Links
            HStack(spacing: 20) {
                Link("Terms of Service", destination: URL(string: "https://www.google.com")!)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Link("Privacy Policy", destination: URL(string: "https://www.google.com")!)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.background)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

// MARK: - Settings Components
struct SettingsSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.headline)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            .padding(.top)
            
            VStack(spacing: 1) {
                content()
            }
            .background(Color.theme.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.background)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 25)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.theme.background)
    }
}

struct SettingsPickerRow: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 25)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.theme.background)
    }
}

struct SettingsSliderRow: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 25)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Slider(value: $value, in: range, step: 15)
                .accentColor(.blue)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.theme.background)
    }
}

struct SettingsNavigationRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let isDestructive: Bool
    let action: () -> Void
    
    init(title: String, subtitle: String, icon: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isDestructive = isDestructive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : .blue)
                    .frame(width: 25)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(isDestructive ? .red : .primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.theme.background)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.light)
        
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
