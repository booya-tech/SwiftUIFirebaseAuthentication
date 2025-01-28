//
//  ProductCellView.swift
//  SwiftUIFirebaseBootcamp
//
//  Created by Panachai Sulsaksakul on 1/14/25.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Price: $\(product.price ?? 0, specifier: "%.2f")")
                Text("Rating: \(product.rating ?? 0, specifier: "%.1f")")
                Text("Category: \(product.category ?? "n/a")")
                Text("Brand: \(product.brand ?? "n/a")")
            }
            .font(.callout)
            .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ProductCellView(product: Product(id: 1, title: "Test", description: "Test", price: 10.0, discountPercentage: 10.0, rating: 10.0, stock: 10, brand: "Test", category: "Test", thumbnail: "Test", images: []))
}
