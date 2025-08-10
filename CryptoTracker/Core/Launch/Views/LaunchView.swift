//
//  LaunchView.swift
//  CryptoTracker
//
//  Created by Prathmesh on 12/10/23.
//

import SwiftUI
//
//struct LaunchView: View {
//    
//    @State private var loadingText: [String] = "Loading your portfolio...".map { String($0) }
//    @State private var showLoadingText: Bool = false
//    @State private var showLogo: Bool = false
//    @State private var showParticles: Bool = false
//    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//    
//    @State private var counter: Int = 0
//    @State private var loops: Int = 0
//    @Binding var showLaunchView: Bool
//    
//    // Animation states
//    @State private var logoRotation: Double = 0
//    @State private var logoScale: CGFloat = 0.5
//    @State private var gradientOffset: CGFloat = -200
//    @State private var particleOffset: [CGFloat] = Array(repeating: 0, count: 20)
//    
//    var body: some View {
//        ZStack {
//            // Dynamic gradient background
//            LinearGradient(
//                colors: [
//                    Color.blue.opacity(0.8),
//                    Color.purple.opacity(0.6),
//                    Color.black.opacity(0.9),
//                    Color.blue.opacity(0.4)
//                ],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//            .background(Color.black)
//            
//            // Animated background particles
//            ForEach(0..<20, id: \.self) { index in
//                FloatingParticle(
//                    delay: Double(index) * 0.2,
//                    show: showParticles
//                )
//            }
//            
//            // Animated gradient overlay
//            LinearGradient(
//                colors: [
//                    Color.clear,
//                    Color.white.opacity(0.1),
//                    Color.clear
//                ],
//                startPoint: .leading,
//                endPoint: .trailing
//            )
//            .frame(width: 100)
//            .offset(x: gradientOffset)
//            .animation(
//                Animation.linear(duration: 2.0)
//                    .repeatForever(autoreverses: false),
//                value: gradientOffset
//            )
//            
//            VStack(spacing: 40) {
//                // Logo section
//                ZStack {
//                    // Glowing background for logo
//                    Circle()
//                        .fill(
//                            RadialGradient(
//                                colors: [
//                                    Color.blue.opacity(0.3),
//                                    Color.purple.opacity(0.2),
//                                    Color.clear
//                                ],
//                                center: .center,
//                                startRadius: 10,
//                                endRadius: 80
//                            )
//                        )
//                        .frame(width: 160, height: 160)
//                        .blur(radius: 10)
//                        .opacity(showLogo ? 1 : 0)
//                    
//                    // Outer ring animation
//                    Circle()
//                        .stroke(
//                            LinearGradient(
//                                colors: [Color.blue, Color.purple, Color.cyan],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            ),
//                            lineWidth: 2
//                        )
//                        .frame(width: 140, height: 140)
//                        .rotationEffect(.degrees(logoRotation))
//                        .opacity(showLogo ? 0.8 : 0)
//                    
//                    // Inner ring animation
//                    Circle()
//                        .stroke(
//                            LinearGradient(
//                                colors: [Color.cyan, Color.blue],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            ),
//                            lineWidth: 1
//                        )
//                        .frame(width: 120, height: 120)
//                        .rotationEffect(.degrees(-logoRotation * 1.5))
//                        .opacity(showLogo ? 0.6 : 0)
//                    
//                    // Main logo
//                    Image("logo-transparent")
//                        .resizable()
//                        .frame(width: 100, height: 100)
//                        .scaleEffect(logoScale)
//                        .rotationEffect(.degrees(logoRotation * 0.1))
//                        .shadow(color: .blue.opacity(0.5), radius: 10, x: 0, y: 0)
//                        .opacity(showLogo ? 1 : 0)
//                }
//                
//                // App title with animation
//                VStack(spacing: 8) {
//                    Text("SwiftfulCrypto")
//                        .font(.system(size: 28, weight: .bold, design: .rounded))
//                        .foregroundStyle(
//                            LinearGradient(
//                                colors: [Color.white, Color.blue.opacity(0.8)],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                        .opacity(showLogo ? 1 : 0)
//                        .offset(y: showLogo ? 0 : 20)
//                    
//                    Text("Your Crypto Portfolio")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.white.opacity(0.7))
//                        .opacity(showLogo ? 1 : 0)
//                        .offset(y: showLogo ? 0 : 20)
//                }
//                
//                Spacer()
//                
//                // Enhanced loading text animation
//                VStack(spacing: 12) {
//                    if showLoadingText {
//                        HStack(spacing: 2) {
//                            ForEach(loadingText.indices, id: \.self) { index in
//                                Text(loadingText[index])
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(
//                                        counter == index ?
//                                        Color.cyan :
//                                        Color.white.opacity(0.7)
//                                    )
//                                    .scaleEffect(counter == index ? 1.2 : 1.0)
//                                    .offset(y: counter == index ? -8 : 0)
//                                    .shadow(
//                                        color: counter == index ? .cyan : .clear,
//                                        radius: counter == index ? 5 : 0
//                                    )
//                                    .animation(
//                                        .spring(response: 0.3, dampingFraction: 0.6),
//                                        value: counter
//                                    )
//                            }
//                        }
//                        .transition(.move(edge: .bottom).combined(with: .opacity))
//                    }
//                    
//                    // Loading progress indicator
//                    HStack(spacing: 4) {
//                        ForEach(0..<3, id: \.self) { index in
//                            Circle()
//                                .fill(Color.cyan)
//                                .frame(width: 8, height: 8)
//                                .scaleEffect(
//                                    (counter % 3) == index ? 1.5 : 1.0
//                                )
//                                .opacity(
//                                    (counter % 3) == index ? 1.0 : 0.5
//                                )
//                                .animation(
//                                    .easeInOut(duration: 0.3),
//                                    value: counter
//                                )
//                        }
//                    }
//                    .opacity(showLoadingText ? 1 : 0)
//                }
//                .padding(.bottom, 60)
//            }
//            .padding()
//        }
//        .onAppear {
//            startAnimations()
//        }
//        .onReceive(timer) { _ in
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                let lastIndex = loadingText.count - 1
//                if counter == lastIndex {
//                    counter = 0
//                    loops += 1
//                    if loops >= 2 {
//                        // Exit animation
//                        withAnimation(.easeInOut(duration: 0.5)) {
//                            logoScale = 0.1
//                            showLoadingText = false
//                        }
//                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            showLaunchView = false
//                        }
//                    }
//                } else {
//                    counter += 1
//                }
//            }
//        }
//    }
//    
//    private func startAnimations() {
//        // Logo entrance animation
//        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
//            showLogo = true
//            logoScale = 1.0
//        }
//        
//        // Continuous logo rotation
//        withAnimation(
//            .linear(duration: 20.0)
//                .repeatForever(autoreverses: false)
//        ) {
//            logoRotation = 360
//        }
//        
//        // Loading text animation
//        withAnimation(.easeInOut(duration: 0.5).delay(1.0)) {
//            showLoadingText = true
//        }
//        
//        // Particles animation
//        withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
//            showParticles = true
//        }
//        
//        // Gradient sweep animation
//        withAnimation(.linear(duration: 2.0).delay(1.5)) {
//            gradientOffset = UIScreen.main.bounds.width + 100
//        }
//    }
//}
//
//struct FloatingParticle: View {
//    let delay: Double
//    let show: Bool
//    @State private var yOffset: CGFloat = 0
//    @State private var xOffset: CGFloat = 0
//    @State private var opacity: Double = 0
//    @State private var rotation: Double = 0
//    
//    private let icons = ["bitcoinsign", "dollarsign", "chart.line.uptrend.xyaxis", "chart.bar.fill"]
//    private let randomIcon: String
//    private let randomX: CGFloat
//    private let randomDuration: Double
//    
//    init(delay: Double, show: Bool) {
//        self.delay = delay
//        self.show = show
//        self.randomIcon = icons.randomElement() ?? "bitcoinsign"
//        self.randomX = CGFloat.random(in: -UIScreen.main.bounds.width/2...UIScreen.main.bounds.width/2)
//        self.randomDuration = Double.random(in: 3.0...6.0)
//    }
//    
//    var body: some View {
//        Image(systemName: randomIcon)
//            .font(.system(size: CGFloat.random(in: 12...20)))
//            .foregroundColor(
//                [Color.blue, Color.cyan, Color.purple, Color.white].randomElement()?.opacity(0.3) ?? Color.blue.opacity(0.3)
//            )
//            .offset(x: randomX + xOffset, y: yOffset)
//            .rotationEffect(.degrees(rotation))
//            .opacity(opacity)
//            .onAppear {
//                if show {
//                    startFloating()
//                }
//            }
//            .onChange(of: show) { newValue in
//                if newValue {
//                    startFloating()
//                }
//            }
//    }
//    
//    private func startFloating() {
//        withAnimation(
//            .linear(duration: randomDuration)
//                .repeatForever(autoreverses: false)
//                .delay(delay)
//        ) {
//            yOffset = -UIScreen.main.bounds.height - 100
//            xOffset = CGFloat.random(in: -50...50)
//            opacity = 1.0
//        }
//        
//        withAnimation(
//            .linear(duration: randomDuration * 0.8)
//                .repeatForever(autoreverses: false)
//                .delay(delay)
//        ) {
//            rotation = 360
//        }
//        
//        // Fade out at the end
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay + randomDuration * 0.8) {
//            withAnimation(.easeOut(duration: randomDuration * 0.2)) {
//                opacity = 0
//            }
//        }
//    }
//}
//
//struct LaunchView_Previews: PreviewProvider {
//    static var previews: some View {
//        LaunchView(showLaunchView: .constant(true))
//    }
//}

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading your portfolio...".map { String($0) }
    @State private var showLoadingText: Bool = false
    @State private var showLogo: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    // Simple animation states
    @State private var logoScale: CGFloat = 0.8
    @State private var logoRotation: Double = 0
    
    var body: some View {
        ZStack {
            // Clean gradient background
            LinearGradient(
                colors: [
                    Color.black,
                    Color.blue.opacity(0.3),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                
                // Enhanced logo section
                ZStack {
                    // Subtle glow effect
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 140, height: 140)
                        .blur(radius: 20)
                        .opacity(showLogo ? 1 : 0)
                    
                    // Logo with subtle animation
                    Image("logo-transparent")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaleEffect(logoScale)
                        .rotationEffect(.degrees(logoRotation))
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        .opacity(showLogo ? 1 : 0)
                }
                
                // App title
                VStack(spacing: 8) {
                    Text("SwiftfulCrypto")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.white, Color.blue.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(showLogo ? 1 : 0)
                    
                    Text("Your Crypto Portfolio")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .opacity(showLogo ? 1 : 0)
                }
                
                Spacer()
                
                // Enhanced loading text
                VStack(spacing: 20) {
                    if showLoadingText {
                        HStack(spacing: 1) {
                            ForEach(loadingText.indices, id: \.self) { index in
                                Text(loadingText[index])
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(
                                        counter == index ?
                                        Color.cyan :
                                        Color.white.opacity(0.8)
                                    )
                                    .scaleEffect(counter == index ? 1.1 : 1.0)
                                    .offset(y: counter == index ? -5 : 0)
                                    .animation(
                                        .spring(response: 0.3, dampingFraction: 0.7),
                                        value: counter
                                    )
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    // Simple loading indicator
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(Color.cyan)
                                .frame(width: 6, height: 6)
                                .scaleEffect((counter % 3) == index ? 1.3 : 0.8)
                                .opacity((counter % 3) == index ? 1.0 : 0.5)
                                .animation(.easeInOut(duration: 0.3), value: counter)
                        }
                    }
                    .opacity(showLoadingText ? 1 : 0)
                }
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            startAnimations()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                let lastIndex = loadingText.count - 1
                if counter == lastIndex {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        // Simple exit animation
                        withAnimation(.easeOut(duration: 0.4)) {
                            showLoadingText = false
                            logoScale = 0.1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            showLaunchView = false
                        }
                    }
                } else {
                    counter += 1
                }
            }
        }
    }
    
    private func startAnimations() {
        // Logo entrance
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
            showLogo = true
            logoScale = 1.0
        }
        
        // Subtle logo rotation
        withAnimation(.linear(duration: 15.0).repeatForever(autoreverses: false)) {
            logoRotation = 360
        }
        
        // Loading text
        withAnimation(.easeIn(duration: 0.4).delay(0.8)) {
            showLoadingText = true
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
