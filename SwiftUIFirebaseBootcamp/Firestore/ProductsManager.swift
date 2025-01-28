//
//  ProductsManager.swift
//  SwiftUIFirebaseBootcamp
//
//  Created by Panachai Sulsaksakul on 1/14/25.
//

import Foundation
import FirebaseFirestore

final class ProductsMananger {
    static let shared = ProductsMananger()
    
    private init() {}
    
    private let productsCollection = Firestore.firestore().collection("products")
    
    private func productDocument(productId: String) -> DocumentReference {
        productsCollection.document(productId)
    }
    
    func updateProduct(product: Product) async throws {
        try productDocument(productId: String(product.id)).setData(from: product, merge: false)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
    // No option select
    private func getAllproducts() async throws -> [Product] {
        try await productsCollection
//            .limit(to: 5)
            .getDocuments(as: Product.self)
    }
    
    // 1 Filter
    private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product] {
        try await productsCollection.order(by: Product.CodingKeys.price.rawValue, descending: descending).getDocuments(as: Product.self)
    }
    
    // 1 Filter
    private func getAllProductsForCategory(category: String) async throws -> [Product] {
        try await productsCollection.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category).getDocuments(as: Product.self)
    }
    
    // 2 Filters
    private func getAllProductsByPriceAndCategory(descending: Bool, category: String) async throws -> [Product] {
        try await productsCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .getDocuments(as: Product.self)
    }
    
    func getAllProducts(priceDescending descending: Bool?,forCategory category: String?) async throws -> [Product] {
        if let descending, let category {
            return try await getAllProductsByPriceAndCategory(descending: descending, category: category)
        } else if let descending {
            return try await getAllProductsSortedByPrice(descending: descending)
        } else if let category {
            return try await getAllProductsForCategory(category: category)
        }
        
        return try await getAllproducts()
    }
}

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        // Better approach compare to append to array
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
//        var products: [T] = []
//        
//        for document in snapshot.documents {
//            let product = try document.data(as: T.self)
//            products.append(product)
//        }
        
//        return products
    }
}
