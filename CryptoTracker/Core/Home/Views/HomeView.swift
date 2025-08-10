//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Prathmesh on 12/10/23.
//


import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false // animate right
    @State private var showPortfolioView: Bool = false // new sheet
    @State private var showSettingsView: Bool = false // new sheet
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                colors: [Color.theme.background, Color.theme.background.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Content layer
            VStack(spacing: 0) {
                modernHeader
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        // Stats Card
                        statsCard
                        
                        // Search and Controls Card
                        searchAndControlsCard
                        
                        // Main Content
                        if !showPortfolio {
                            allCoinsCard
                        } else {
                            portfolioCard
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100) // Extra space for tab bar
                }
            }
            .sheet(isPresented: $showPortfolioView) {
                PortfolioView()
                    .environmentObject(vm)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() })
        )
    }
}

// MARK: - UI Components
extension HomeView {
    
    private var modernHeader: some View {
        VStack(spacing: 16) {
            // Top bar with actions
            HStack {
                // Left action button
                Button(action: {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }) {
                    Image(systemName: showPortfolio ? "plus.circle.fill" : "gearshape.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .scaleEffect(showPortfolio ? 1.0 : 1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showPortfolio)
                
                Spacer()
                
                // Title with animated background
                VStack(spacing: 4) {
                    Text(showPortfolio ? "Portfolio" : "Live Prices")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.accent)
                    
                    Text(showPortfolio ? "Your investments" : "Market overview")
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.theme.background.opacity(0.8))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
                
                Spacer()
                
                // Toggle button
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showPortfolio.toggle()
                    }
                }) {
                    Image(systemName: "arrow.left.arrow.right.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: showPortfolio ? [.green, .blue] : [.orange, .red],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .shadow(color: (showPortfolio ? Color.green : Color.orange).opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .rotationEffect(.degrees(showPortfolio ? 180 : 0))
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.theme.background)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
    
    private var statsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HomeStatsView(showPortfolio: $showPortfolio)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.background)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    private var searchAndControlsCard: some View {
        VStack(spacing: 16) {
            // Enhanced search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.theme.secondaryText)
                    .font(.headline)
                
                SearchBarView(searchText: $vm.searchText)
                
                // Refresh button
                Button(action: {
                    withAnimation(.linear(duration: 2.0)) {
                        vm.reloadData()
                    }
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(vm.isLoading ? 360 : 0))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.background.opacity(0.5))
                    .stroke(Color.theme.secondaryText.opacity(0.2), lineWidth: 1)
            )
            
            // Sort controls
            modernColumnTitles
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.background)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    private var modernColumnTitles: some View {
        HStack(spacing: 12) {
            // Coin sort button
            SortButton(
                title: "Coin",
                isActive: vm.sortOption == .rank || vm.sortOption == .rankReversed,
                isReversed: vm.sortOption == .rankReversed
            ) {
                withAnimation(.spring()) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            // Holdings sort button (only in portfolio view)
            if showPortfolio {
                SortButton(
                    title: "Holdings",
                    isActive: vm.sortOption == .holdings || vm.sortOption == .holdingsReversed,
                    isReversed: vm.sortOption == .holdingsReversed
                ) {
                    withAnimation(.spring()) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
                
                Spacer()
            }
            
            // Price sort button
            SortButton(
                title: "Price",
                isActive: vm.sortOption == .price || vm.sortOption == .priceReversed,
                isReversed: vm.sortOption == .priceReversed
            ) {
                withAnimation(.spring()) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
        }
    }
    
    private var allCoinsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("All Cryptocurrencies")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accent)
                
                Spacer()
                
                Text("\(vm.allCoins.count) coins")
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.theme.secondaryText.opacity(0.1))
                    )
            }
            
            LazyVStack(spacing: 12) {
                ForEach(vm.allCoins) { coin in
                    ModernCoinRow(coin: coin, showHoldingsColumn: false)
                        .onTapGesture {
                            segue(coin: coin)
                        }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.background)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
        .transition(.move(edge: .leading).combined(with: .opacity))
    }
    
    private var portfolioCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Portfolio")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accent)
                
                Spacer()
                
                if !vm.portfolioCoins.isEmpty {
                    Text("\(vm.portfolioCoins.count) holdings")
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.green.opacity(0.1))
                        )
                }
            }
            
            if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                portfolioEmptyState
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(vm.portfolioCoins) { coin in
                        ModernCoinRow(coin: coin, showHoldingsColumn: true)
                            .onTapGesture {
                                segue(coin: coin)
                            }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.background)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
        .transition(.move(edge: .trailing).combined(with: .opacity))
    }
    
    private var portfolioEmptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.pie")
                .font(.system(size: 50))
                .foregroundColor(.blue.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Your portfolio is empty")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accent)
                
                Text("Start building your crypto portfolio by adding some coins!")
                    .font(.callout)
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showPortfolioView = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Coins")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
    }
    
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}

// MARK: - Supporting Components
struct SortButton: View {
    let title: String
    let isActive: Bool
    let isReversed: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(isActive ? .semibold : .medium)
                
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .opacity(isActive ? 1.0 : 0.3)
                    .rotationEffect(.degrees(isReversed ? 180 : 0))
            }
            .foregroundColor(isActive ? .blue : Color.theme.secondaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isActive ? Color.blue.opacity(0.1) : Color.clear)
                    .stroke(isActive ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
    }
}

struct ModernCoinRow: View {
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Coin info section
            HStack(spacing: 12) {
                CoinImageView(coin: coin)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(coin.symbol.uppercased())
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.accent)
                    
                    Text(coin.name)
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
            
            Spacer()
            
            // Holdings section (if needed)
            if showHoldingsColumn {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.accent)
                    
                    Text((coin.currentHoldings ?? 0).asNumberString())
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
            
            // Price section
            VStack(alignment: .trailing, spacing: 2) {
                Text(coin.currentPrice.asCurrencyWith6Decimals())
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accent)
                
                HStack(spacing: 4) {
                    Image(systemName: "triangle.fill")
                        .font(.caption2)
                        .rotationEffect(.degrees((coin.priceChangePercentage24H ?? 0) >= 0 ? 0 : 180))
                        .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? .green : .red)
                    
                    Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? .green : .red)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.background.opacity(0.5))
                .stroke(Color.theme.secondaryText.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}
