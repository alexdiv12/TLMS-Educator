import SwiftUI

struct HomeView: View {
    @State private var courses: [Course] = sampleCourses
    @State private var educatorsList : [Educator] = sampleEducators
    
    var body: some View {
        NavigationView{
            ScrollView {
                Color.secondaryColor
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    TaglineView()
                        .padding(.horizontal)
                    
                    // Search Bar
                    HStack {
                        TextField("Search", text: .constant(""))
                            .padding(10)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    ActivityView()
                        .listRowBackground(Color.clear)
                        .padding(.horizontal,30)
                    HStack {
                        Text("Top Educators")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        NavigationLink(destination: EducatorsListView(educators: educatorsList)) {
                            Text("See All")
                                .foregroundColor(Color.primaryColor)
                        }
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(educatorsList) { educator in
                                NavigationLink(destination: EducatorDetailView(educator: educator)) {
                                    EducatorView(educator: educator)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    // Trending Courses
                    HStack {
                        Text("Trending Courses")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        NavigationLink(destination: AllCoursesGridView(courses: courses)) {
                            Text("See All")
                                .foregroundColor(Color.primaryColor)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack() {
                            ForEach(courses) { course in
                                NavigationLink(destination: CourseDetailView(course: course)){
                                    CourseCardView(course: course)
                                }
                            }
                        }
                        .padding(.top,-10)
                        .padding()
                    }
                    
                }
            }
            .onAppear{
                Services.fetchListOfEducators(){ educators in
                    self.educatorsList = educators
                }
                Services.fetchListOfCourses(){ courses in
                    self.courses = courses
                }
            }
            .navigationTitle("Home")
            .navigationBarItems(trailing: Button(action: {
                print("Tapped")
            }) {
                Image(systemName: "bell.fill")
                    .font(.title3)
                    .foregroundColor(Color.primaryColor)
            })
            
        }
    }
}

struct CategoryView: View {
    let imageName: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 60, height: 60)
                .background(Color.gray)
                .cornerRadius(30)
            Text(title)
                .font(.caption)
        }
        
    }
}


//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

// Sample Data
let sampleCourses: [Course] = [
    Course(id: "1", educatorEmail: "email", educatorName: "Prakash Sharma", name: "Web Development", description: "Learn web development from scratch.", duration: "12h 52m", language: "English", price: "Rs.1,500", category: "Coding", keywords: "web, development", imageUrl: "https://media.geeksforgeeks.org/wp-content/uploads/20230331172641/NodeJS-copy.webp", averageRating: 4.0, videos: [Video(id: UUID(), title: "Intro", videoURL: URL(string: "https://example.com/intro.mp4")!)], notes: [Note(id: UUID(), title: "Note 1", url: URL(string: "https://example.com/note1.pdf")!)]),
    Course(id: "2", educatorEmail: "gmial", educatorName: "Instructor Name", name: "Complete Swift ", description: "Course description here.", duration: "10h 20m", language: "English", price: "Rs.1,200", category: "Tech", keywords: "Coding, skills", imageUrl: "https://i.ytimg.com/vi/NIJLFZk9SdA/hq720.jpg?sqp=-oaymwEXCK4FEIIDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLA_XpfR4VFvwAGUwnN2JdQ34-g76g", averageRating: 4.0, videos: [Video(id: UUID(), title: "Lesson 1", videoURL: URL(string: "https://example.com/lesson1.mp4")!)], notes: [Note(id: UUID(), title: "Note 2", url: URL(string: "https://example.com/note2.pdf")!)]),
    Course(id: "2", educatorEmail: "hotmail", educatorName: "Instructor Name", name: "Another Course", description: "Course description here.", duration: "10h 20m", language: "English", price: "Rs.1,200", category: "Business", keywords: "business, skills", imageUrl: "https://i.ytimg.com/vi/NIJLFZk9SdA/hq720.jpg?sqp=-oaymwEXCK4FEIIDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLA_XpfR4VFvwAGUwnN2JdQ34-g76g", averageRating: 4.0, videos: [Video(id: UUID(), title: "Lesson 1", videoURL: URL(string: "https://example.com/lesson1.mp4")!)], notes: [Note(id: UUID(), title: "Note 2", url: URL(string: "https://example.com/note2.pdf")!)])
]

let sampleEducators: [Educator] = [Educator(name: "reload", email: "", mobileNumber: "", qualification: "", experience: "", subjectDomain: "", language: "", aadharImageURL: "", profileImageURL: "", about: "")]
//    Educator(id: UUID(), name: "Educator 2", imageName: "PrsadSir"),
//    Educator(id: UUID(), name: "Educator 3", imageName: "ViragSir"),
//    Educator(id: UUID(), name: "Educator 3", imageName: "ViragSir"),
//    Educator(id: UUID(), name: "Educator 1", imageName: "Educator1"),
//    Educator(id: UUID(), name: "Educator 2", imageName: "PrsadSir"),
//]

struct AppBarView: View {
    var body: some View {
        HStack{
            Text("Hello,")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Image(systemName: "bell.fill")
                .font(.title)
                .foregroundColor(Color.primaryColor)
        }
    }
}


struct TaglineView: View {
    var body: some View {
        Text("Find Your Best Courses!")
            .font(.custom("PlayfairDisplay-Regular", size: 22))
            .foregroundColor(Color.primaryColor)
    }
}

struct EducatorListView: View {
    @State private var educatorsList : [Educator] = sampleEducators
    var body: some View {
        VStack {
            Text("Educator List")
                .font(.title)
                .fontWeight(.bold)
            List {
                ForEach(educatorsList) { educator in
                    EducatorView(educator: educator)
                }
            }
        }
    }
}

struct AllCoursesGridView: View {
    var courses: [Course]
    @EnvironmentObject var courseViewModel: CourseViewModel
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(courses) { course in
                    NavigationLink(destination: CourseDetailView(course: course).environmentObject(courseViewModel)) {
                        CourseCardView(course: course)
                    }
                }
            }
            .padding(.top, 10)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Courses")
    }
}
    struct CourseCardView: View {
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
                        HStack{
                            Text(course.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text("₹ \(course.price)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
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
    
    //struct CourseCardView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        CourseCardView(course: sampleCourses[0])
    //    }
    //}
    
    struct CourseDetailsView: View {
        var course: Course
        
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: course.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(height: 200)
                .clipped()
                
                Text(course.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(course.description)
                    .font(.body)
                
                HStack {
                    Text("Duration: \(course.duration)")
                    Spacer()
                    Text("Language: \(course.language)")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(course.name)
        }
    }

