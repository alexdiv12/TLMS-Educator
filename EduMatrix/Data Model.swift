//
//  Data Model.swift
//  EduMatrix
//
//  Created by Madhav Verma on 11/07/24.
//

import Foundation

struct Educator : Identifiable, Codable, Hashable {
    var id: String?
    var name: String
    var email: String
    var mobileNumber: String
    var qualification: String
    var experience: String
    var subjectDomain: String
    var language: String
    let aadharImageURL: String
    let profileImageURL : String
    let about: String
    
}


struct Course: Identifiable , Codable{ // Ensure Course conforms to Identifiable
    var id: String
    var educatorEmail : String
    var educatorName: String
    var name: String
    var description: String
    var duration: String
    var language: String
    var price: String
    var category: String
    var keywords: String
    var imageUrl: String
    var averageRating: Double
    var videos: [Video]?
    var notes: [Note]?
    var videoProgress: [VideoProgress]?
    
    var overallProgress: Double {
        guard let videoProgress = videoProgress, let videos = videos else { return 0.0 }
        let completedVideos = videoProgress.filter { $0.completed }.count
        return Double(completedVideos) / Double(videos.count)
    }
    init(id: String, educatorEmail: String, educatorName: String, name: String, description: String, duration: String, language: String, price: String, category: String, keywords: String, imageUrl: String, averageRating: Double, videos: [Video]?, notes: [Note]?, videoProgress: [VideoProgress]? = nil) {
            self.id = id
            self.educatorEmail = educatorEmail
            self.educatorName = educatorName
            self.name = name
            self.description = description
            self.duration = duration
            self.language = language
            self.price = price
            self.category = category
            self.keywords = keywords
            self.imageUrl = imageUrl
            self.averageRating = averageRating
            self.videos = videos
            self.notes = notes
            self.videoProgress = videoProgress
        }
}

struct Video: Identifiable , Codable{
    var id: UUID
    var title: String
    var videoURL: URL
}

struct Note: Identifiable , Codable{
    var id: UUID
    var title: String
    var url: URL
}
struct VideoProgress: Codable {
    var videoID: UUID
    var completed: Bool
}

struct Learner {
    var id: String
    var name: String?
    var email: String
    var password : String
    var mobileNumber: String?
    var Domain: String?
    var enrolledCourses : [String]?
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "email": email,
            "password": password,
//            "description": description,
//            "duration": duration,
            
        ]
    }
}
