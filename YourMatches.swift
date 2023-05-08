//
//  YourMatches.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 4/5/2023.
//

import Foundation
import SwiftUI
import URLImage

func getYourMatches(userId: String) {
    let url = URL(string: "http://localhost:9090/matche/notamie/\(userId)")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let parameters: [String: Any] = ["userid": userId]
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

    
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            // Handle error
            return
        }

        do {
            // Parse JSON data into an array of dictionaries
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
            print("getYourMatchesgetYourMatchesgetYourMatches",jsonArray)
            var friends: [Friend] = []

            jsonArray.forEach { dict in
               
                if
                     let id = dict["id"] as? String,
        
                        let firstName = dict["FirstName"] as? String,
                        let image = dict["Image"] as? String , let lasteName=dict["LasteName"]as? String{
                  
                    let friend = Friend(id: id,FirstName: firstName,  Image: image,LasteName:lasteName)
                    
                    friends.append(friend)
                    print("ididididididid",id)
                    
                }
            }

            self.data1 = friends
            print("data1data1data1data1data1",self.data1)


        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    task.resume()
}
struct YourMatchesRow: View {
    @State var data1 = [Friend]()
    @State private var navigationLinkIsActive = false
    @State var romeName: String = ""
    let login: String

    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                
                HStack {
               
                     
                        URLImage(URL(string: data1.Image)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(50)
                        }
                    
                   
                    
                    ZStack {
                        
                        VStack(alignment: .leading) {
                            Text(data1.FirstName)
                                .font(.system(size: 21, weight: .medium, design: .default))
                           
                            Text(data1.LasteName)
                                .font(.system(size: 10, weight: .medium, design: .default))
                                .foregroundColor(.red)
                        }
                    }
                   
//                    VStack {
//                        Spacer()
//
//                        VStack(alignment: .leading) {
//                            Text(data.LasteName)
//                                .font(.system(size: 10, weight: .medium, design: .default))
//
//                        }
//                    }
                }.padding(.horizontal , -170)
            }
        }
           
        }
    }
struct Friend1:  Identifiable, Codable  {
    let id: String
    let FirstName: String
    let Image: String
    let LasteName: String
}
