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
    
    func getAllproducts() async throws {
        self.products = try await ProductsMananger.shared.getAllproducts()
    }
}

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List(viewModel.products) { product in
            ProductCellView(product: product)
        }
        .navigationTitle("Products")
        .task {
            try? await viewModel.getAllproducts()
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
}
