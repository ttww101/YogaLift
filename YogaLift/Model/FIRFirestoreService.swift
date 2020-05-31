//
//  FirestoreService.swift
//   WorkOutLift
//
//  Created by Apple on 2019/7/5.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation
//import Firebase

class FIRFirestoreService {
    
    private init() {}
    static let shared = FIRFirestoreService()
    
    func configure() {
//        FirebaseApp.configure()
    }
    
    let today = Date()
    
//    lazy var user = Auth.auth().currentUser
    
//    lazy var uid = user!.uid
    
//    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
//        return Firestore.firestore().collection(collectionReference.rawValue)
//    }
    
//    func firebase(query: (CollectionReference) -> Query) {
//
//        let query = query(Firestore.firestore().collection("users"))
//
//        query.getDocuments(completion: {_,_ in
//
//        })
//    }

//    private func userSubReference(to collectionReference: FIRCollectionReference) -> CollectionReference {
//
//        Firestore.firestore().collection("users")
//
//        return Firestore.firestore()
//            .collection("users").document(uid)
//            .collection(collectionReference.rawValue)
//    }
    
    func create(
        with datas: [String: Any],
        in subCollectionReference: FIRCollectionReference? = nil,
        documentID: String? = nil,
        completion: @escaping (Error?) -> Void
    ) {
        
        var json: [String: Any] = [:]
        
        json = datas
        
        if let subCollectionReference = subCollectionReference {
            
            if let documentID = documentID {
//                userSubReference(to: subCollectionReference).document(documentID).setData(json, completion: completion)
            } else {
//                userSubReference(to: subCollectionReference).addDocument(data: json)
            }
        
        } else {
//            reference(to: .users).document(user!.uid).setData(json, completion: completion)
        }
        
    }
    
    func create<T: Encodable>(
        for encodableObject: T,
        in collectionReference: FIRCollectionReference,
        completion: @escaping (Error?) -> Void) {
        do {
            let json = try encodableObject.toJson()
//            reference(to: .users).document(user!.uid).setData(json, completion: completion)
        } catch {
            print(error)
        }
    }
    
    func read<T: Decodable>(
        from collectionReference: FIRCollectionReference,
        returning objectType: T.Type,
        completion: @escaping ([T]) -> Void) {
        
//        reference(to: collectionReference).addSnapshotListener { (snapshot, _) in
//
//            guard let snapshot = snapshot else { return }
//
//            do {
//                var objects = [T]()
//                for document in snapshot.documents {
//                    let object = try document.decode(as: objectType.self)
//                    objects.append(object)
//                }
//
//                completion(objects)
//
//            } catch {
//                print(error)
//            }
//
//        }
        
    }
    
    func update<T: Encodable & Identifiable>(
        for encodableObject: T,
        in collectionReference: FIRCollectionReference) {
        
        do {
            let json = try encodableObject.toJson()
            guard let id = encodableObject.id else { throw LWError.encodingError }
//            reference(to: collectionReference).document(id).setData(json)
            
        } catch {
            print(error)
        }
        
    }
    
    func delete<T: Identifiable>(
        _ identifiableObject: T,
        in collectionReference: FIRCollectionReference) {
        
        do {
            guard let id = identifiableObject.id else { throw LWError.encodingError}
//            reference(to: collectionReference).document(id).delete()
            
        } catch {
            print(error)
        }
        
    }
    
//    func createUser(
//        email: String,
//        password: String,
//        completion: AuthDataResultCallback?) {
//        
//        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
//        
//    }
//    
//    func login(
//        email: String,
//        password: String,
//        completion: AuthDataResultCallback?) {
//        
//        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
//    }
}
