//
//  ExploreView.swift
//  EduMatrix
//
//  Created by Shahiyan Khan on 04/07/24.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                // Top Image
                Spacer()
                Image(systemName: "sparkles")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .foregroundColor(.blue)
                
                // Title
                Text("Explore EduMatrix")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                // Subtitle
                Text("Now your learnings are in one place and always with you")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                VStack{         // Login Buttons
                    Button(action: {
                        // Continue with Apple action
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Continue with Apple")
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.top, 10)
                        .padding(.horizontal)
                    }
                    
                    // Continue with Google Button
                    Button(action: {
                        // Continue with Google action
                    }) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Continue with Google")
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.top, 10)
                        .padding(.horizontal)
                    }
                    
                }
                .padding(.top, 40)
                NavigationLink(destination: LoginView()) {
                                   Text("Already have an account? Log in")
                                       .foregroundColor(.blue)
                                       .underline()
                    
                    
                               }
                
                Spacer()
            }
            .background(Color(.systemGray6))
        }
        .navigationBarHidden(true)
        
    }
        
}

#Preview {
    ExploreView()
}
