import SwiftUI
import UIKit
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var selectedMonth = Date()
    @State private var profileImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isActionSheetPresented = false
    @EnvironmentObject var viewRouter:ViewRouter
    
    var body: some View {
        NavigationView {
            List {
                // Header with profile image and user details
                HeaderView(profileImage: $profileImage, isActionSheetPresented: $isActionSheetPresented)
                    .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity)
                
                // Streaks section
                StreaksCardView(selectedMonth: $selectedMonth)
                    .listRowBackground(Color.clear)
                
                // Activity section
                ActivityView()
                    .listRowBackground(Color.clear)
                    .padding(.top, 20)
                
                // Action sections
                ActionSectionsView()
            }
            //.navigationBarTitle("Profile", displayMode: .inline)
        }
        .actionSheet(isPresented: $isActionSheetPresented) {
            ActionSheet(
                title: Text("Upload Photo"),
                //message: Text("Choose a source"),
                buttons: [
                    .default(Text("Gallery")) {
                        imagePickerSourceType = .photoLibrary
                        isImagePickerPresented = true
                    },
                    .default(Text("Camera")) {
                        imagePickerSourceType = .camera
                        isImagePickerPresented = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(sourceType: $imagePickerSourceType, selectedImage: $profileImage)
        }
        
    }
}

struct HeaderView: View {
    @Binding var profileImage: UIImage?
    @Binding var isActionSheetPresented: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                // Profile image
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.top, 10) // Adjusted padding
                        .background(Circle().fill(Color.orange))
                        .padding(.bottom, 10)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .padding(.top, 10) // Adjusted padding
                        .background(Circle().fill(Color.orange))
                        .padding(.bottom, 10)
                }
                
                // Pencil icon for editing
                Button(action: {
                    isActionSheetPresented = true
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .background(Circle().fill(Color.white))
                }
                .padding(5)
            }
            
            // User details
            Text("Sunny Siddhu")
                .font(.title2)
                .fontWeight(.bold)
            Text("sunnysiddhu886@gmail.com")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20) // Adjusted padding
    }
}



//import Firebase

struct StreaksCardView: View {
    @Binding var selectedMonth: Date
    @State private var streaks: [String: Bool] = [:] // Dictionary to hold streak data
    @State private var user: User?
    
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        Text("Your Streaks")
            .font(.headline)
            .padding(.bottom, 10)
            .padding(.leading, -10)
        
        VStack(alignment: .leading) {
            // Month Selector
            HStack {
                Button(action: {
                    changeMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                        .padding()
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                }
                Spacer()
                Text(getMonthYearString(from: selectedMonth))
                    .font(.title3)
                Spacer()
                Button(action: {
                    changeMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                        .padding()
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                }
            }
            .padding(.vertical)
            
            // Days of the Week Header
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Streaks Calendar
            VStack {
                let days = generateDaysInMonth(for: selectedMonth)
                ForEach(days.chunked(into: 7), id: \.self) { week in
                    HStack {
                        ForEach(week, id: \.self) { date in
                            let dateString = getDateString(from: date)
                            let isStreak = streaks[dateString] ?? false
                            Circle()
                                .fill(isStreak ? Color.orange : Color.gray.opacity(0.2))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Circle()
                                        .stroke(Color.orange, lineWidth: 2)
                                )
                                .opacity(Calendar.current.isDate(date, equalTo: selectedMonth, toGranularity: .month) ? 1 : 0)
                        }
                    }
                }
            }
            .padding()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 1))
        .onAppear {
            fetchStreaks()
        }
        .onChange(of: selectedMonth) { _ in
            fetchStreaks()
        }
        .padding([.leading, .trailing], -16)
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) {
            selectedMonth = newDate
        }
    }
    
    private func getMonthYearString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func generateDaysInMonth(for date: Date) -> [Date] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: date) else {
            return []
        }
        
        let days = range.compactMap { day -> Date? in
            var components = Calendar.current.dateComponents([.year, .month], from: date)
            components.day = day
            return Calendar.current.date(from: components)
        }
        
        // Calculate the number of leading and trailing days needed to fill the calendar grid
        let firstDayOfMonth = days.first!
        let weekday = Calendar.current.component(.weekday, from: firstDayOfMonth) - 1
        let leadingDays = (0..<weekday).map { _ in Date.distantPast }
        
        let lastDayOfMonth = days.last!
        let weekdayLast = Calendar.current.component(.weekday, from: lastDayOfMonth)
        let trailingDays = (weekdayLast..<7).map { _ in Date.distantPast }
        
        return leadingDays + days + trailingDays
    }
    
    private func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    private func fetchStreaks() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let streaksRef = db.collection("streaks").document(user.uid)
        
        streaksRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.streaks = document.data() as? [String: Bool] ?? [:]
            } else {
                print("Document does not exist or error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
   


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for i in stride(from: 0, to: self.count, by: size) {
            let chunk = Array(self[i..<Swift.min(i + size, self.count)])
            chunks.append(chunk)
        }
        return chunks
    }
}



struct ActivityView: View {
    var subjects: [(subject: String, percentage: Int, color: Color)] = [
        (subject: "Math", percentage: 78, color: .orange),
        (subject: "Physics", percentage: 16, color: .blue),
        (subject: "Chemistry", percentage: 6, color: .yellow)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Activity")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading, -20)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Learnings")
                        Text("01 jul 2024 - \(Date.now.formatted(date: .abbreviated, time: .omitted))")
                            .foregroundColor(.gray)
                        Text("12 hrs 52 min")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    // Pie chart with data
                    PieChartView(data: subjects)
                        .frame(width: 100, height: 100)
                        .padding(.top, 10)
                }
                Divider()
                // Subjects breakdown
                HStack {
                    ForEach(subjects, id: \.subject) { subject in
                        SubjectTagView(subject: subject.subject, percentage: subject.percentage, color: subject.color)
                            .background(RoundedRectangle(cornerRadius: 15).fill(subject.color))
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 1))
            .padding([.leading, .trailing], -16)
            .frame(maxWidth: .infinity) // Ensure the card takes the maximum available width
        }
    }
}

struct SubjectTagView: View {
    let subject: String
    let percentage: Int
    let color: Color
    
    var body: some View {
       
            Text("\(percentage)% \(subject)")
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(5)
    }
}

struct PieChartView: View {
    var data: [(subject: String, percentage: Int, color: Color)]
    
    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            let total = data.reduce(0) { $0 + $1.percentage }
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    let segment = data[index]
                    let startAngle = angle(at: index, in: data, total: total)
                    let endAngle = angle(at: index + 1, in: data, total: total)
                    
                    PieChartSegment(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, color: segment.color)
                }
            }
        }
    }
    
    private func angle(at index: Int, in data: [(subject: String, percentage: Int, color: Color)], total: Int) -> Angle {
        let percentage = data.prefix(index).reduce(0) { $0 + $1.percentage }
        return Angle(degrees: Double(percentage) / Double(total) * 360 - 90)
    }
}

struct PieChartSegment: View {
    var center: CGPoint
    var radius: CGFloat
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    
    var body: some View {
        Path { path in
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
        .fill(color)
    }
}

struct ActionSectionsView: View {
    @State private var showLogoutAlert = false
    @EnvironmentObject var viewRouter:ViewRouter
    var body: some View {
        
        Section {
            NavigationLink(destination: UserView()) {
                ActionButton(title: "Personal Information", iconName: "person.circle.fill")
            }
        }
        
        Section {
            NavigationLink(destination: ForgotPasswordView()) {
                ActionButton(title: "Forgot Password", iconName: "key.fill")
            }
            NavigationLink(destination: HelpSupportView()) {
                ActionButton(title: "Help & Support", iconName: "questionmark.circle.fill")
            }
            NavigationLink(destination: UserView()) {
                ActionButton(title: "Change your subscription", iconName: "creditcard.fill")
            }
        }
        
        Section {
            Button(action: {
                showLogoutAlert = true
            }) {
                ActionButton(title: "Log out", iconName: "arrow.right.circle.fill")
            }
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Are you sure to logout?"),
                    primaryButton: .destructive(Text("Logout")) {
                       logout()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
         
    }
    func logout() {
           do {
               try Auth.auth().signOut()
               viewRouter.currentPage = .login
           } catch let signOutError as NSError {
               print("Error signing out: \(signOutError.localizedDescription)")
           }
       }
}

struct ActionButton: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .cornerRadius(10)
  
    }
}


// ImagePicker to handle image selection from gallery or camera
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
