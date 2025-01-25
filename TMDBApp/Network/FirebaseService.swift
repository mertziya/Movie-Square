//
//  AuthService.swift
//  TMDBApp
//
//  Created by Mert Ziya on 13.01.2025.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FirebaseCore

class FirebaseService{
    static var shared = FirebaseService()
    
    func signInUsingGoogle(vc : UIViewController){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { [unowned vc] result, error in
          guard error == nil else {
              print(error?.localizedDescription ?? "Error")
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            print("Token Error")
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error{
                    print(error.localizedDescription)
                }
                else if let _ = result{
                    DispatchQueue.main.async {
                        guard let user = result?.user else{print("DEBUG: No User") ; return}
                        self.createUserInFirestore(user: user)
                        let tabBarVC = TabVC()
                        tabBarVC.modalPresentationStyle = .fullScreen
                        vc.present(tabBarVC , animated: true)
                    }
                }else{
                    print("Unknown Error")
                }
            }
        }
    }
    

    func createUser(email: String, password: String , completion: @escaping (Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            if let user = authResult?.user {
                completion(nil)
            }
        }
    }
    
    func signUserInWithemail(email : String , password: String , completion : @escaping (Error?) -> () ){
        Auth.auth().signIn(withEmail: email, password: password) { res, error in
            if let error = error{
                completion(error)
            }else if let res = res{
               completion(nil)
            }
        }
    }
    
    
    
    func createUserInFirestore(user: User){
        let firestore = Firestore.firestore()
        let users = firestore.collection("users")
        
        let data : [String : Any] = [
            "email" : user.email ?? "null@email.com",
            "userid" : user.uid,
            "bookmarkedMovies" : [],
            "bookmarkedSeries" : [],
        ]
        
        let userDoc = users.document(user.uid)
        
        users.document(user.uid).getDocument { doc, err in
            if let err = err{
                print("Error checking if the user exist")
                return
            }
            
            if let doc = doc, doc.exists{ // User already exist in the firestore db
                print("exist?")
                return
            }
            else{ // User doesnt exist in the firestore db
                userDoc.setData(data) { error in
                    if let error = error{
                        print(error.localizedDescription)
                    }else{
                        print("Success")
                    }
                }
            }
            
        }
    }
    
    func addMovieToBookmark(movie : Movie , completion: @escaping (Error?) -> () ) {
        let db = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else{completion(ErrorTypes.firebaseUserError) ; return}
        let userDocument = db.collection("users").document(currentUser.uid) // current user's document path
        
        let movieData : [String : Any] = [
            "id" : movie.id ?? "nil",
            "title" : movie.title ?? "nil",
        ]
        
        userDocument.updateData(["bookmarkedMovies" : FieldValue.arrayUnion([movieData])]) { error in
            if let error = error{
                completion(error)
            }else{
                completion(nil)
            }
        }
    }
    
    func addSeriesToBookmark(series : Series , completion: @escaping (Error?) -> () ) {
        let db = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else{completion(ErrorTypes.firebaseUserError) ; return}
        let userDocument = db.collection("users").document(currentUser.uid) // current user's document path
        
        let seriesData : [String : Any] = [
            "id" : series.id ?? "nil",
            "title" : series.name ?? "nil",
        ]
        
        userDocument.updateData(["bookmarkedSeries" : FieldValue.arrayUnion([seriesData])]) { error in
            if let error = error{
                completion(error)
            }else{
                completion(nil)
            }
        }
    }
    
    
    // Gives the boolean value 'true' on the completion block if the given paramater 'movie' is already bookmarked by the user
    // If the movie is not bookmarked by the user it gives the boolean value "false"
    func checkIfBookmarkedMovie(movie : Movie , completion : @escaping (Result<Bool,Error>) -> () ){
        let db = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else{completion(.failure(ErrorTypes.URLError)) ; return}
        
        let userDocument = db.collection("users").document(currentUser.uid) // current user's document path.
        
        userDocument.getDocument { document, error in
            if let error = error{
                completion(.failure(error))
                return
            }else if let document = document, document.exists{
                // Access the bookmarkedMovies field
                
                if let bookmarkedMovies = document.get("bookmarkedMovies") as? [[String: Any]] {
                    for theMovie in bookmarkedMovies {
                        guard let movieID = theMovie["id"] as? Int else{completion(.failure(ErrorTypes.unknownError)) ; return}
                        if movie.id == movieID{
                            
                            completion(.success(true))
                            return
                        }
                    }
                    completion(.success(false))
                    return
                }
                    
            }
            else{
                completion(.failure(ErrorTypes.unknownError))
            }
        }
    }
    
    
    // Gives the boolean value 'true' on the completion block if the given paramater 'series' is already bookmarked by the user
    // If the series is not bookmarked by the user it gives the boolean value "false"
    func checkIfBookmarkedSeries(series : Series , completion : @escaping (Result<Bool,Error>) -> () ){
        let db = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else{completion(.failure(ErrorTypes.URLError)) ; return}
        
        let userDocument = db.collection("users").document(currentUser.uid) // current user's document path.
        
        userDocument.getDocument { document, error in
            if let error = error{
                completion(.failure(error))
                return
            }else if let document = document, document.exists{
                // Access the bookmarkedMovies field
                
                if let bookmarkedSeries = document.get("bookmarkedSeries") as? [[String: Any]] {
                    for theSeries in bookmarkedSeries {
                        guard let seriesID = theSeries["id"] as? Int else{completion(.failure(ErrorTypes.unknownError)) ; return}
                        if series.id == seriesID{
                            print(seriesID)
                            completion(.success(true))
                            return
                        }
                    }
                    completion(.success(false))
                    return
                }
                    
            }
            else{
                completion(.failure(ErrorTypes.unknownError))
            }
        }
    }
    
    
    func deleteMovieFromBookmarks(with movie : Movie , completion : @escaping (Error?) -> ()) {
        let db = Firestore.firestore()
        guard let currentUserId = Auth.auth().currentUser?.uid else{completion(ErrorTypes.firebaseUserError) ; return}
        let userDocument = db.collection("users").document(currentUserId)
        
        let dataToBeUpdated : [String : Any] = [
            "id" : movie.id ?? 0,
            "title" : movie.title ?? "",
        ]
        
        userDocument.updateData(["bookmarkedMovies" : FieldValue.arrayRemove([dataToBeUpdated])]) { error in
            if let error = error{
                completion(error)
            }else{
                completion(nil)
            }
        }
    }
    
    func deleteSeriesFromBookmarks(with series : Series , completion : @escaping (Error?) -> ()){
        let db = Firestore.firestore()
        guard let currentUserId = Auth.auth().currentUser?.uid else{completion(ErrorTypes.firebaseUserError) ; return}
        let userDocument = db.collection("users").document(currentUserId)
        
        let data : [String : Any] = [
            "id" : series.id ?? 0,
            "title" : series.name ?? "",
        ]
        
        userDocument.updateData(["bookmarkedSeries" : FieldValue.arrayRemove([data])]) { error in
            if let error = error{
                completion(error)
            }else{
                completion(nil)
            }
        }
    }
    
    // Returnns all the movie IDs inside the completion block for later usage
    // Planned to use for fetching movie with the movie id
    func fetchAllBookmarkedMovieIDS(completion : @escaping (Result<[Int],Error>) ->() ){
        guard let currentUID = Auth.auth().currentUser?.uid else{completion(.failure(ErrorTypes.firebaseUserError)) ; return}
        let db = Firestore.firestore()
        let currentDocument = db.collection("users").document(currentUID)
        
        var bookmarkIdArray : [Int] = []
        
        currentDocument.getDocument { document, error in
            if let error = error{
                completion(.failure(error))
            }else if let document = document{
                do{
                    let bookmarkContainer = try document.data(as: bookmarkContainer.self, decoder: Firestore.Decoder())
                    let bookmarkedMovies = bookmarkContainer.bookmarkedMovies
                    for movie in bookmarkedMovies{
                        bookmarkIdArray.append(movie.id)
                    }
                    completion(.success(bookmarkIdArray))
                }catch{
                    completion(.failure(error))
                }
                
            }else{
                completion(.failure(ErrorTypes.unknownError))
            }
        }
    }
    
    
    // Returnns all the movie IDs inside the completion block for later usage
    // Planned to use for fetching movie with the movie id
    func fetchAllBookmarkedSeriesIDS(completion : @escaping (Result<[Int],Error>) ->() ){
        guard let currentUID = Auth.auth().currentUser?.uid else{completion(.failure(ErrorTypes.firebaseUserError)) ; return}
        let db = Firestore.firestore()
        let currentDocument = db.collection("users").document(currentUID)
        
        var bookmarkIdArray : [Int] = []
        
        currentDocument.getDocument { document, error in
            if let error = error{
                completion(.failure(error))
            }else if let document = document{
                do{
                    let bookmarkContainer = try document.data(as: bookmarkContainer.self, decoder: Firestore.Decoder())
                    let bookmarkedSeries = bookmarkContainer.bookmarkedSeries
                    for series in bookmarkedSeries{
                        bookmarkIdArray.append(series.id)
                    }
                    completion(.success(bookmarkIdArray))
                }catch{
                    completion(.failure(error))
                }
                
            }else{
                completion(.failure(ErrorTypes.unknownError))
            }
        }
    }
    
    
}
