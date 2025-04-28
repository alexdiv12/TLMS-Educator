import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct EduMatrixApp: App {
    @StateObject private var courseViewModel = CourseViewModel()
    @StateObject private var viewRouter = ViewRouter()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(courseViewModel)
                .environmentObject(viewRouter)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        Group {
            switch viewRouter.currentPage {
            case .login:
                LoginView()
            case .content:
                ContentView()
            }
        }
        .onAppear {
            if Auth.auth().currentUser != nil {
                viewRouter.currentPage = .content
            } else {
                viewRouter.currentPage = .login
            }
        }
    }
}
