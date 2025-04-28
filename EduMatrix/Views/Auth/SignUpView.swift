//
//  SignUpView.swift
//  EduMatrix
//
//  Created by Shahiyan Khan on 04/07/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        VStack {
            Image("SignUpImage") // Replace with your image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            
            Text("Sign up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.top, 10)
            
            SecureField("must be 8 characters", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.top, 10)
            
            SecureField("repeat password", text: $confirmPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.top, 10)
            
            Button(action: {
                if validateFields() {
                    Services.createAccount(email: email, password: password) { success in
                        if success {
                            viewRouter.currentPage = .content
                        } else {
                            alertMessage = "Failed to create account. Please try again."
                            showAlert = true
                        }
                    }
                }
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.top, 20)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
            
            HStack {
                Text("Already have an account?")
                NavigationLink(destination: LoginView()) {
                    Text("Log in")
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 20)
        .navigationBarHidden(true)
    }

    private func validateFields() -> Bool {
        if !isValidEmail(email) {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return false
        }
        
        if password.count < 8 {
            alertMessage = "Password must be at least 8 characters long."
            showAlert = true
            return false
        }
        
        if password != confirmPassword {
            alertMessage = "Passwords do not match."
            showAlert = true
            return false
        }
        
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(ViewRouter())
    }
}
