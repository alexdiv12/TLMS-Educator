import SwiftUI

struct MyCoursesView: View {
    @EnvironmentObject var courseViewModel: CourseViewModel
    @State private var selectedTab = 0
    @State private var enrolledCourses : [Course] = [Course]()

    var body: some View {
        NavigationView {
            VStack {
                // Custom Segmented Control
                HStack {
                    Button(action: {
                        selectedTab = 0
                    }) {
                        Text("Ongoing")
                            .fontWeight(selectedTab == 0 ? .bold : .regular)
                            .foregroundColor(selectedTab == 0 ? .blue : .gray)
//                        padding(.horizontal)
                    }
                    .padding(.horizontal,55)

                    Spacer()
                    Button(action: {
                        selectedTab = 1
                    }) {
                        Text("Completed")
                            .fontWeight(selectedTab == 1 ? .bold : .regular)
                            .foregroundColor(selectedTab == 1 ? .blue : .gray)
//                            .padding(.horizontal)
                    }
                    .padding(.horizontal,55)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                // Indicator
                HStack {
                    Rectangle()
                        .fill(selectedTab == 0 ? Color.blue : Color.clear)
                        .frame(height: 2)
                        .animation(.default)
                    Rectangle()
                        .fill(selectedTab == 1 ? Color.blue : Color.clear)
                        .frame(height: 2)
                        .animation(.default)
                }
                
                ScrollView {
                    ForEach(selectedTab == 0 ? enrolledCourses : courseViewModel.completedCourses) { course in
                        NavigationLink(destination: CourseDetailView(course: course).environmentObject(courseViewModel)) {
                            MyCourseCardView(course: course)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, 10)
            }
            .navigationBarTitle("My Courses", displayMode: .inline)
//            .navigationBarItems(trailing: NavigationLink(destination: WishlistView().environmentObject(courseViewModel)) {
//                Image(systemName: "heart")
//            })
            .onAppear(){
                fetchEnrolledCourses()
            }
        }
    }
    func fetchEnrolledCourses(){
        Services.fetchOnGoingCourses(){ courses in
            self.enrolledCourses = courses
        }
    }
}

struct WishlistView: View {
    @EnvironmentObject var courseViewModel: CourseViewModel

    var body: some View {
        List {
            ForEach(courseViewModel.wishlistCourses) { course in
                NavigationLink(destination: CourseDetailView(course: course).environmentObject(courseViewModel)) {
                    Text(course.name)
                }
            }
        }
        .navigationBarTitle("Wishlist")
    }
}

struct MyCourseCardView: View {
    let course: Course

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Image section
                if let url = URL(string: course.imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    } placeholder: {
                        Color.gray
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    }
                } else {
                    Color.gray
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                
                // Blur section with description
                VStack(alignment: .leading, spacing: 5) {
                    Text(course.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    HStack {
                        Text("By \(course.educatorName)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Spacer()
                        HStack {
                            ForEach(0..<5) { star in
                                Image(systemName: star < Int(course.averageRating) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.headline)
                                    .padding(.horizontal,-5)
                            }
                        }
                    }
                    HStack {
                        ProgressView(value: course.overallProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.white))
                        Text("\(Int(course.overallProgress * 100))%")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal)
                .background(BlurView(style: .systemMaterialDark).opacity(0.80))
                .frame(height: geometry.size.height / 3) // 1/3rd height of the card
            }
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.vertical, 5)
        }
        .aspectRatio(16/9, contentMode: .fit) // Adjust aspect ratio as needed
        .frame(width: UIScreen.main.bounds.width - 40)
    }
}

// BlurView for the blur effect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}


//struct MyCoursesView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleCourses = [
//                    Course(
//                        id: "1",
//                        educatorEmail: "educator@example.com",
//                        educatorName: "John Doe",
//                        name: "Java",
//                        description: "Learn Java from scratch.",
//                        duration: "10",
//                        language: "English",
//                        price: "999",
//                        category: "Programming",
//                        keywords: "Java, Programming",
//                        imageUrl: "https://via.placeholder.com/150",
//                        averageRating: 4.0,
//                        videos: [
//                            Video(id: UUID(), title: "Introduction", url: URL(string: "https://www.example.com/video1.mp4")!),
//                            Video(id: UUID(), title: "Lesson 1", url: URL(string: "https://www.example.com/video2.mp4")!)
//                        ],
//                        notes: nil
//                    ),
//                    Course(
//                        id: "2",
//                        educatorEmail: "educator2@example.com",
//                        educatorName: "Jane Smith",
//                        name: "Swift UI",
//                        description: "Learn SwiftUI for iOS development.",
//                        duration: "10",
//                        language: "English",
//                        price: "999",
//                        category: "Programming",
//                        keywords: "SwiftUI, iOS",
//                        imageUrl: "https://via.placeholder.com/150",
//                        averageRating: 4.5,
//                        videos: [
//                            Video(id: UUID(), title: "Introduction", url: URL(string: "https://www.example.com/video1.mp4")!),
//                            Video(id: UUID(), title: "Lesson 1", url: URL(string: "https://www.example.com/video2.mp4")!)
//                        ],
//                        notes: nil
//                    )
//                ]
//                
//                let courseViewModel = CourseViewModel()
//                courseViewModel.enrolledCourses = sampleCourses
//                courseViewModel.completedCourses = sampleCourses // Add some sample completed courses for testing
//                
//                return MyCoursesView()
//                    .environmentObject(courseViewModel)
//    }
//}
