import SwiftUI
import AVKit
import FirebaseFirestore
import FirebaseAuth

struct CourseDetailView: View {
    @EnvironmentObject var courseViewModel: CourseViewModel
    let course: Course
    @State private var showAlert = false
    @State private var isEnrolled = false
    @State private var selectedVideoURL: URL?
    @State private var videoProgress: [UUID: Bool] = [:]
    @State private var currentPlayer: AVPlayer?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Video Player or Image section
                if let videoURL = selectedVideoURL {
                    VideoPlayer(player: currentPlayer)
                        .frame(height: 250)
                        .cornerRadius(10)
                        .padding(.bottom)
                        .onDisappear {
                            currentPlayer?.pause()
                        }
                } else if let url = URL(string: course.imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 250)
                    .cornerRadius(10)
                }
                
                // Course title
                Text(course.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                // Educator and rating
                HStack {
                    Text("By")
                        .font(.headline)
                    Text("\(course.educatorName)")
                    Spacer()
                    HStack {
                        ForEach(0..<5) { star in
                            Image(systemName: star < Int(course.averageRating) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.headline)
                                .padding(.horizontal,-5)
                        }
                      
                    }
//                    Text(String(format: "%.1f", course.averageRating))
//                        .font(.headline)
                }
                
                if !isEnrolled {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Duration:")
                                .font(.headline)
                            Text("\(course.duration) hrs")
                            Spacer()
                        }
                        .padding(.vertical, 2)
                        
                        HStack {
                            Text("Category:")
                                .font(.headline)
                            Text("\(course.category)")
                            Spacer()
                        }
                        .padding(.vertical, 2)
                        
                        HStack {
                            Text("Language:")
                                .font(.headline)
                            Text("\(course.language)")
                            Spacer()
                        }
                        .padding(.vertical, 2)
                        
                        // Price
                        HStack {
                            Text("Price:")
                                .font(.headline)
                            Text("Rs.\(course.price)")
                            Spacer()
                        }
                        .padding(.vertical, 2)
                    }
                }
                
                if isEnrolled {
                    // Lesson section
                    VStack(alignment: .leading) {
                        Text("Lessons")
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        ForEach(course.videos!) { video in
                            HStack {
                                Button(action: {
                                    if let currentPlayer = currentPlayer {
                                        currentPlayer.pause()
                                    }
                                    selectedVideoURL = video.videoURL
                                    currentPlayer = AVPlayer(url: video.videoURL)
                                    currentPlayer?.play()
                                    updateStreak()
                                }){
                                    HStack {
                                        Image(systemName: "play.circle.fill")
                                            .foregroundColor(.blue)
                                            .font(.title2)
                                        Text(video.title)
                                            .padding(.vertical, 10)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                
                                Toggle("", isOn: Binding(
                                    get: {
                                        courseViewModel.enrolledCourses.first(where: { $0.id == course.id })?.videoProgress?.first(where: { $0.videoID == video.id })?.completed ?? false
                                    },
                                    set: { value in
                                        courseViewModel.updateProgress(for: course.id, videoID: video.id, completed: value)
                                    }
                                ))
                                .toggleStyle(.button)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    // Progress bar
                    HStack {
                        ProgressView(value: course.overallProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                        Text("\(Int(course.overallProgress * 100))%")
                            .font(.subheadline)
                    }
                    .padding(.top, 10)
                } else {
                    // Description
                    VStack(alignment: .leading) {
                        Text(course.description)
                            .font(.body)
                            .padding(.bottom, 10)
                        
                        // Enroll button
                        Button(action: {
                            showAlert = true
                            print("Enroll Now button tapped")
                        }) {
                            Text("Enroll Now")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Enroll in Course"),
                                message: Text("Are you sure you want to enroll in this course?"),
                                primaryButton: .default(Text("Yes")) {
                                    db.collection("learners").document(email).updateData([
                                        "enrolledCourses": FieldValue.arrayUnion([course.id])
                                    ]) { error in
                                        if let error = error {
                                            print("Error updating document: \(error)")
                                        } else {
                                            print("Course successfully added to enrolledCourses")
                                        }
                                    }
                                    isEnrolled = true
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    .padding(.vertical)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle(Text(course.name), displayMode: .inline)
        .onAppear {
            db.collection("learners").document(email).getDocument { document, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                }
                if let document = document, document.exists {
                    if let enrolledCourses = document.get("enrolledCourses") as? [String] {
                        if enrolledCourses.contains(course.id) {
                            isEnrolled = true
                        }
                    }
                }
            }
//            docRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    isSignIn = true
//                    print("Login Successful")
//                    viewRouter.currentPage = .content
//                } else {
//                    alertMessage = "User role mismatch. Expected: Educator"
//                    showAlert = true
//                    do {
//                        try Auth.auth().signOut()
//                    } catch let signOutError as NSError {
//                        alertMessage = "Error signing out: \(signOutError.localizedDescription)"
//                        showAlert = true
//                    }
//                }
//            }
//            isEnrolled = courseViewModel.enrolledCourses.contains(where: { $0.id == course.id })
        }
    }
    private func updateStreak() {
            guard let user = Auth.auth().currentUser else {
                print("User not logged in")
                return
            }
            
            let db = Firestore.firestore()
            let streaksRef = db.collection("streaks").document(user.uid)
            let dateString = getDateString(from: Date())
            
            streaksRef.setData([dateString: true], merge: true) { error in
                if let error = error {
                    print("Error updating streak: \(error.localizedDescription)")
                } else {
                    print("Streak updated for \(dateString)")
                }
            }
        }
        
        private func getDateString(from date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
    }


struct CourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let course = Course(
            id: "1",
            educatorEmail: "educator@example.com",
            educatorName: "John Doe",
            name: "Sample Course",
            description: "This is a sample course description.",
            duration: "10",
            language: "English",
            price: "999",
            category: "Programming",
            keywords: "Swift, iOS",
            imageUrl: "https://via.placeholder.com/150",
            averageRating: 4.5,
            videos: [
                Video(id: UUID(), title: "Introduction", videoURL: URL(string: "https://www.pexels.com/video/close-up-video-of-a-person-writing-855953")!),
                Video(id: UUID(), title: "Lesson 1", videoURL: URL(string: "https://www.pexels.com/video/close-up-video-of-a-person-writing-855953/")!)
            ],
            notes: nil
        )
        
        CourseDetailView(course: course)
            .environmentObject(CourseViewModel())
    }
}
