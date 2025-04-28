//
//  ContentView.swift
//  EduMatrix
//
//  Created by Madhav Verma on 03/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            HomeView()
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            MyCoursesView()
            .tabItem {
                Image(systemName: "book")
                Text("My Courses")
            }
            ProfileView()
                .tabItem{
                    Image(systemName: "person")
                    Text("My Profile")
                }
        }
    }
}

#Preview {
    ContentView()
}
