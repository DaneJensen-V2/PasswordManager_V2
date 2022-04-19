//
//  AuthManager.swift
//  Shareable
//
//  Created by Dane Jensen on 2/7/22.
//

import Foundation
import Firebase
let auth = Auth.auth()

class AuthManager{
    let db = Firestore.firestore()

    static let shared = AuthManager()
    
    
    private var verificationID : String?
    
   
    func loadCurrentUser(user : User,  completion: @escaping (Bool) -> Void){
        print("ID: " + user.uid)
        let docRef = db.collection("Users").document(user.uid)

        docRef.getDocument { (document, error) in

            let result = Result {
              try document?.data(as: UserData.self)
            }
            switch result {
            case .success(let loadedUser):
                if let loadedUser = loadedUser {
                    currentUser = loadedUser
                    
                    completion(true)
                    print("Loaded User")
                    print(currentUser.firstName)
                    print(currentUser.lastName)

                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("Error decoding city: \(error)")
            }
        }
        
    }
   public func logout(){
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
       
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
    }
}
