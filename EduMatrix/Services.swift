//
//  Services.swift
//  EduMatrix
//
//  Created by Madhav Verma on 11/07/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Services{
    static func loadImage(from url: URL , completion : @escaping (UIImage) -> Void){
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load image from \(url): \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data)!)
            }
        }.resume()
    }
    

    

    static func fetchListOfEducators(completion: @escaping ([Educator]) -> Void) {
        var educators : [Educator] = []
        let db = Firestore.firestore()
        
        db.collection("educators").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                educators = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    print(data)
                    return Educator(
                        id: document.documentID,
                        name: data["fullName"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        mobileNumber: data["mobileNumber"] as? String ?? "",
                        qualification: data["qualification"] as? String ?? "",
                        experience: data["experience"] as? String ?? "",
                        subjectDomain: data["subjectDomain"] as? String ?? "",
                        language: data["language"] as? String ?? "",
                        aadharImageURL: data["aadharImageURL"] as?  String ?? "",
                        profileImageURL: data["profileImageURL"] as? String ?? "",
                        about: data["about"] as? String ?? ""
                    )
                } ?? []
            }
            completion(educators)
        }
    }
   
    static func fetchListOfCourses(completion: @escaping ([Course]) -> Void) {
        var courses : [Course] = []
        let db = Firestore.firestore()
        db.collection("courses").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            courses = documents.compactMap { doc in
                let data = doc.data()
                
                // Decode videos
                var videos = [Video]()
                if let videosData = data["videos"] as? [[String: Any]] {
                    videos = videosData.compactMap { videoData in
                        return Video(id: UUID(uuidString: videoData["id"] as! String)!, title: videoData["title"] as? String ?? "", videoURL: URL(string: videoData["videoURL"] as? String ?? "")!)
                    }
                }
                
                // Create the course object
                return Course(
                    id: data["id"] as? String ?? "",
                    educatorEmail: data["educatorEmail"] as? String ?? "",
                    educatorName: data["educatorName"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    duration: data["duration"] as? String ?? "",
                    language: data["language"] as? String ?? "",
                    price: data["price"] as? String ?? "",
                    category: data["category"] as? String ?? "",
                    keywords: data["keywords"] as? String ?? "",
                    imageUrl: data["imageUrl"] as? String ?? "",
                    averageRating: data["averageRating"] as? Double ?? 0.0,
                    videos: videos,
                    notes: nil
                )
            }
            completion(courses)
        }
    }
    
    static func fetchOnGoingCourses(completion: @escaping ([Course]) -> Void) {
            let db = Firestore.firestore()
            var courses: [Course] = []
            let dispatchGroup = DispatchGroup()

            db.collection("learners").document(email).getDocument { document, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    completion([])
                    return
                }
                if let document = document, document.exists {
                    if let enrolledCourses = document.get("enrolledCourses") as? [String] {
                        for courseId in enrolledCourses {
                            dispatchGroup.enter()
                            db.collection("courses").document(courseId).getDocument { snapshot, error in
                                defer { dispatchGroup.leave() }
                                if let error = error {
                                    print("Error fetching course document: \(error)")
                                    return
                                }
                                guard let docum = snapshot, let data = docum.data() else {
                                    print("No course document found")
                                    return
                                }
                                
                                // Decode videos
                                var videos = [Video]()
                                if let videosData = data["videos"] as? [[String: Any]] {
                                    videos = videosData.compactMap { videoData in
                                        guard let idString = videoData["id"] as? String,
                                              let id = UUID(uuidString: idString),
                                              let title = videoData["title"] as? String,
                                              let urlString = videoData["videoURL"] as? String,
                                              let url = URL(string: urlString) else {
                                            return nil
                                        }
                                        return Video(id: id, title: title, videoURL: url)
                                    }
                                }
                                
                                // Create the course object
                                let course = Course(
                                    id: data["id"] as? String ?? "",
                                    educatorEmail: data["educatorEmail"] as? String ?? "",
                                    educatorName: data["educatorName"] as? String ?? "",
                                    name: data["name"] as? String ?? "",
                                    description: data["description"] as? String ?? "",
                                    duration: data["duration"] as? String ?? "",
                                    language: data["language"] as? String ?? "",
                                    price: data["price"] as? String ?? "",
                                    category: data["category"] as? String ?? "",
                                    keywords: data["keywords"] as? String ?? "",
                                    imageUrl: data["imageUrl"] as? String ?? "",
                                    averageRating: data["averageRating"] as? Double ?? 0.0,
                                    videos: videos,
                                    notes: nil
                                )
                                courses.append(course)
                            }
                        }

                        // Wait for all tasks to complete
                        dispatchGroup.notify(queue: .main) {
                            completion(courses)
                        }
                    } else {
                        print("No enrolled courses found")
                        completion([])
                    }
                } else {
                    print("Document does not exist")
                    completion([])
                }
            }
        }
    
    static func createAccount(email : String , password : String , completion : @escaping (Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                var learner = Learner(id: UUID().uuidString, email: email, password: password)
                let db = Firestore.firestore()
                db.collection("learners").document(email).setData(learner.toDictionary()) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                        completion(false)
                    } else {
                        print("User signed up successfully")
                        completion(true)
                    }
                }
            }
        }
    }
    
}

let db = Firestore.firestore()
let email : String = (Auth.auth().currentUser?.email)!
