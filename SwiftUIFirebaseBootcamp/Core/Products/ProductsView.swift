//
//  ProductsView.swift
//  SwiftUIFirebaseBootcamp
//
//  Created by Panachai Sulsaksakul on 1/14/25.
//

import SwiftUI

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published var selectedFilter: FilterOption? = nil
    @Published var selectedCategory: CategoryOption? = nil
    
    enum FilterOption: String, CaseIterable {
        case noFilter
        case priceHigh
        case priceLow
        
        var priceDescending: Bool? {
            switch self {
            case .noFilter: return nil
            case .priceHigh: return true
            case .priceLow: return false
            }
        }
    }
    
    func filterSelected(option: FilterOption) async throws {
        // set filter to priceHigh
        self.selectedFilter = option
        self.getProducts()
        
//        switch option {
//        case .noFilter:
//            self.products = try await ProductsMananger.shared.getAllproducts()
//        case .priceHigh, .priceLow:
//            // query
//            self.products = try await ProductsMananger.shared.getAllProductsSortedByPrice(descending: true)
//        }

    }
    
    enum CategoryOption: String, CaseIterable {
        case noCategory
        case furniture
        case beauty
        case fragrances
        
        var categoryKey: String? {
            if self == .noCategory { return nil }
            
            return self.rawValue
        }
    }
    
    func categorySelected(option: CategoryOption) async throws {
        // set filter to priceHigh
        self.selectedCategory = option
        self.getProducts()
        
//        switch option {
//        case .noCategory:
//            self.products = try await ProductsMananger.shared.getAllproducts()
//        case .furniture, .beauty, .fragrances:
//            // query
//            self.products = try await ProductsMananger.shared.getAllProductsForCategoty(category: option.rawValue)
//        }
    }
    
    func getProducts() {
        Task {
            self.products = try await ProductsMananger.shared.getAllProducts(
                priceDescending: selectedFilter?.priceDescending,
                forCategory: selectedCategory?.categoryKey
            )
        }
    }
}

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List(viewModel.products) { product in
            ProductCellView(product: product)
        }
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.FilterOption.allCases, id:\.self) { filterOption in
                        Button(filterOption.rawValue) {
                            Task {
                                try await viewModel.filterSelected(option: filterOption)
                            }
                        }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Filter: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.CategoryOption.allCases, id:\.self) { categoryOption in
                        Button(categoryOption.rawValue) {
                            Task {
                                try await viewModel.categorySelected(option: categoryOption)
                            }
                        }
                    }
                }
            }
        })
        .onAppear {
            viewModel.getProducts()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
