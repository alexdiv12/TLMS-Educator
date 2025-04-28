import Foundation
import SwiftUI
class CourseViewModel: ObservableObject {
    @State var enrolledCourses: [Course] = []
    @Published var completedCourses: [Course] = []
    @Published var wishlistCourses: [Course] = []
    
//    func enroll(course: Course) {
//        if !enrolledCourses.contains(where: { $0.id == course.id }) {
//            var newCourse = course
//            newCourse.videoProgress = course.videos?.map { VideoProgress(videoID: $0.id, completed: false) }
//            enrolledCourses.append(newCourse)
//        }
//    }
    
    func onGoingCourses(){
        Services.fetchOnGoingCourses(){ courses in
            self.enrolledCourses = courses
        }
    }
    
    func updateProgress(for courseID: String, videoID: UUID, completed: Bool) {
        if let courseIndex = enrolledCourses.firstIndex(where: { $0.id == courseID }) {
            if let videoIndex = enrolledCourses[courseIndex].videoProgress?.firstIndex(where: { $0.videoID == videoID }) {
                enrolledCourses[courseIndex].videoProgress?[videoIndex].completed = completed
                
                if let totalProgress = enrolledCourses[courseIndex].videoProgress?.filter({ $0.completed }).count,
                   let videoCount = enrolledCourses[courseIndex].videos?.count,
                   totalProgress == videoCount {
                    completeCourse(courseID: courseID)
                }
            }
        }
    }
    
    func completeCourse(courseID: String) {
        if let courseIndex = enrolledCourses.firstIndex(where: { $0.id == courseID }) {
            let completedCourse = enrolledCourses.remove(at: courseIndex)
            completedCourses.append(completedCourse)
        }
    }
    
    func toggleWishlist(course: Course) {
        if let index = wishlistCourses.firstIndex(where: { $0.id == course.id }) {
            wishlistCourses.remove(at: index)
        } else {
            wishlistCourses.append(course)
        }
    }
}
