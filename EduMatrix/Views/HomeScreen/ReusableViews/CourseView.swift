import Foundation
import SwiftUI

struct CourseView: View {
    let course: Course
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image section
            if let url = URL(string: course.imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 280, height: 150)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 280, height: 150)
                            .clipped()
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo") // Placeholder image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 280, height: 150)
                            .clipped()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 280, height: 150)
                            .clipped()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
            } else {
                Color(.systemGray6)
                    .frame(width: 280, height: 150)
                    .cornerRadius(10)
            }
            
            // Text section
            VStack(alignment: .leading, spacing: 5) {
                Text(course.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(course.educatorName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    Text(course.price)
                        .font(.headline)
                        .foregroundColor(.primary)
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
                HStack(spacing: 15) {
                    HStack(spacing: 5) {
                        Image(systemName: "clock.fill")
                        Text(course.duration)
                    }
                    HStack(spacing: 5) {
                        Image(systemName: "book.fill")
                        Text("\(course.videos?.count ?? 0) Lessons")
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding([.horizontal, .bottom])
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .frame(width: 300, height: 250)
        .padding(.vertical, 10)
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView(course: Course(
            id: "1",
            educatorEmail: "email",
            educatorName: "Virag",
            name: "Web Development",
            description: "Learn web development from scratch.",
            duration: "12h 52m",
            language: "English",
            price: "Rs.1,500",
            category: "Coding",
            keywords: "web, development",
            imageUrl: "https://via.placeholder.com/280x150",
            averageRating: 4.0,
            videos: [Video(id: UUID(), title: "Intro", videoURL: URL(string: "https://example.com/intro.mp4")!)],
            notes: [Note(id: UUID(), title: "Note 1", url: URL(string: "https://example.com/note1.pdf")!)]
        ))
    }
}
