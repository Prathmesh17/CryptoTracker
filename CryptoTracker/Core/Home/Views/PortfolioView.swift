//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by Prathmesh on 12/10/23.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        NavigationView {
            ZStack {
                // Modern gradient background
                LinearGradient(
                    colors: [Color.theme.background, Color.theme.background.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        // Header section with search
                        searchSection
                        
                        // Coin selection section
                        coinSelectionSection
                        
                        // Portfolio input section
                        if selectedCoin != nil {
                            portfolioInputCard
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        
                        // Quick stats if portfolio exists
                        if !vm.portfolioCoins.isEmpty {
                            portfolioStatsCard
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Edit Portfolio")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    modernCloseButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    modernSaveButton
                }
            }
            .onChange(of: vm.searchText) { value in
                if value == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

// MARK: - UI Components
extension PortfolioView {
    
    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("Search & Add Coins")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accent)
                
                Spacer()
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.theme.secondaryText)
                    .font(.headline)
                
                SearchBarView(searchText: $vm.searchText)
                
                if !vm.searchText.isEmpty {
                    Button(action: {
                        vm.searchText = ""
                        removeSelectedCoin()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.background.opacity(0.7))
                    .stroke(Color.theme.secondaryText.opacity(0.2), lineWidth: 1)
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.background)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    private var coinSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "bitcoinsign.circle.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
                
                Text(vm.searchText.isEmpty ? "Your Holdings" : "Available Coins")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accent)
                
                Spacer()
                
                Text("\((vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins).count)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(vm.searchText.isEmpty ? .green : .blue)
                    )
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                        ModernCoinCard(
                            coin: coin,
                            isSelected: selectedCoin?.id == coin.id,
                            showHoldings: vm.searchText.isEmpty
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.background)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    private var portfolioInputCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                CoinImageView(coin: selectedCoin!)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedCoin?.name ?? "")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.accent)
                    
                    Text(selectedCoin?.symbol.uppercased() ?? "")
                        .font(.caption)
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Rank #\(selectedCoin?.rank ?? 0)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(.blue)
                        )
                }
            }
            
            Divider()
                .background(Color.theme.secondaryText.opacity(0.3))
            
            // Current Price Section
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current Price")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.theme.secondaryText)
                        
                        Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.accent)
                    }
                    
                    Spacer()
                    
                    // Price change indicator
                    HStack(spacing: 4) {
                        Image(systemName: "triangle.fill")
                            .font(.caption2)
                            .rotationEffect(.degrees((selectedCoin?.priceChangePercentage24H ?? 0) >= 0 ? 0 : 180))
                            .foregroundColor((selectedCoin?.priceChangePercentage24H ?? 0) >= 0 ? .green : .red)
                        
                        Text(selectedCoin?.priceChangePercentage24H?.asPercentString() ?? "")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor((selectedCoin?.priceChangePercentage24H ?? 0) >= 0 ? .green : .red)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill((selectedCoin?.priceChangePercentage24H ?? 0) >= 0 ? .green.opacity(0.1) : .red.opacity(0.1))
                    )
                }
                
                // Holdings Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount Holding")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    HStack {
                        TextField("Enter amount (e.g., 1.5)", text: $quantityText)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.background.opacity(0.5))
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                        
                        Text(selectedCoin?.symbol.uppercased() ?? "")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.accent)
                            .padding(.leading, 8)
                    }
                }
                
                // Current Value Display
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Value")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    HStack {
                        Text(getCurrentValue().asCurrencyWith2Decimals())
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        if getCurrentValue() > 0 {
                            Text("≈ \((Double(quantityText) ?? 0).asNumberString()) \(selectedCoin?.symbol.uppercased() ?? "")")
                                .font(.caption)
                                .foregroundColor(Color.theme.secondaryText)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.theme.secondaryText.opacity(0.1))
                                )
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
        .animation(.none, value: quantityText)
    }
    
    private var portfolioStatsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .font(.title2)
                    .foregroundColor(.purple)
                
                Text("Portfolio Summary")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accent)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Total Holdings",
                    value: "\(vm.portfolioCoins.count)",
                    icon: "bitcoinsign.circle.fill",
                    color: .orange
                )
                
                StatCard(
                    title: "Total Value",
                    value: vm.portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +).asCurrencyWith2Decimals(),
                    icon: "dollarsign.circle.fill",
                    color: .green
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.background)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
    }
    
    private var modernCloseButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.title2)
                .foregroundColor(.gray)
        }
    }
    
    private var modernSaveButton: some View {
        HStack(spacing: 8) {
            if showCheckmark {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.green)
                    .transition(.scale.combined(with: .opacity))
            }
            
            Button(action: {
                saveButtonPressed()
            }) {
                HStack(spacing: 6) {
                    if !showCheckmark {
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.caption)
                    }
                    Text("Save")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
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
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.3
            )
            .disabled(selectedCoin == nil || selectedCoin?.currentHoldings == Double(quantityText))
        }
    }
    
    // MARK: - Functions
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin,
              let amount = Double(quantityText) else { return }
        
        // Save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // Show checkmark with animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        // Hide keyboard
        UIApplication.shared.endEditing()
        
        // Hide checkmark after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}

// MARK: - Supporting Components
struct ModernCoinCard: View {
    let coin: CoinModel
    let isSelected: Bool
    let showHoldings: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Coin image and selection indicator
            ZStack {
                CoinImageView(coin: coin)
                    .frame(width: 50, height: 50)
                
                if isSelected {
                    Circle()
                        .stroke(Color.blue, lineWidth: 3)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .background(Circle().fill(.white))
                                .offset(x: 20, y: -20)
                        )
                }
            }
            
            // Coin info
            VStack(spacing: 4) {
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.accent)
                
                Text(coin.name)
                    .font(.caption2)
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 24)
                
                if showHoldings && coin.currentHoldings != nil {
                    Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }
        }
        .frame(width: 100, height: 120)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? Color.blue.opacity(0.1) : Color.theme.background.opacity(0.7))
                .stroke(isSelected ? Color.blue : Color.theme.secondaryText.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
                
                Text(value)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Preview
struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}
