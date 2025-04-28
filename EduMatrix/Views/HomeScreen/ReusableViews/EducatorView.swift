//
//  EducatorView.swift
//  EduMatrix
//
//  Created by Shahiyan Khan on 10/07/24.
//

import Foundation
import SwiftUI
struct EducatorView: View {
    let educator: Educator
    
    var body: some View {
        if let url = URL(string: educator.profileImageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView() // A loading indicator while the image is being fetched
                        .frame(width: 70, height: 70)
                        .background(Color(.systemGray6))
                        .cornerRadius(35)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .frame(width: 70, height: 70)
                        .background(Color.gray)
                        .cornerRadius(35)
                case .failure:
                    Image("reload") // A placeholder image in case of failure
                        .resizable()
                        .frame(width: 70, height: 70)
                        .background(Color.gray)
                        .cornerRadius(35)
                @unknown default:
                    Image("reload")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .background(Color.gray)
                        .cornerRadius(35)
                }
            }
        }
    }
}
//
//#Preview {
//    EducatorView(educator: <#T##Educator#>)
//}
