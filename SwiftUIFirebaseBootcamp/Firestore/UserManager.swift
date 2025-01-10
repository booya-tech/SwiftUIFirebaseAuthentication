//
//  UserManager.swift
//  SwiftUIFirebaseBootcamp
//
//  Created by Panachai Sulsaksakul on 1/9/25.
//

import Foundation
import FirebaseFirestore

struct DBUser {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
}

final class UserManager {
    static let shared = UserManager()
    
    func createNewUser(auth: AuthResultDataModel) async throws {
        var userData: [String: Any] = [
            "user_id" : auth.uid,
            "is_anonymous" : auth.isAnonymous,
            "date_created" : Timestamp()
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let photoUrl = auth.photoUrl {
            userData["photoUrl"] = photoUrl
        }
        
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userid: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userid).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let isAnonymous = data["is_anonymous"] as? Bool
        let email = data["email"] as? String
        let photoUrl = data["photoUrl"] as? String
        let dateCreated = data["date_created"] as? Date
        
        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
    }
}
