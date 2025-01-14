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
    
    func getAllproducts() async throws -> [Product] {
        try await productsCollection.getDocuments(as: Product.self)
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
