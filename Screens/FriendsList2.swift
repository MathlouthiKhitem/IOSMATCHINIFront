//
//  FriendsList2.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 16/5/2023.
//

import SwiftUI
import URLImage

struct FriendsList2: View {
    
    let login: String
    @State var data = [Friend2]()

    func getUserId(login : String , completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "http://localhost:9090/user/getId") else {
           
            return
        }
        
        let parameters = ["login": login]
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
             
                completion(nil, error)
                return
            }
            
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let returnedid = responseJSON["value"] as? String {
                    completion(returnedid, nil)
                } else {
                    ("Invalid response")
                    completion(nil, NSError(domain: "com.yourapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                }
            } else {
                print("Invalid JSON data")
                completion(nil, NSError(domain: "com.yourapp", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON data"]))
            }
           
        }.resume()
    }
    func getFriendList(userId: String) {
        let url = URL(string: "http://localhost:9090/matche/notamie/\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
             
                var friends2: [Friend2] = []

                jsonArray.forEach { dict in
                    
                    if
                         let id = dict["id"] as? String,
            
                            let firstName = dict["FirstName"] as? String,
                            let image = dict["Image"] as? String {
                      
                        let friend = Friend2(id: id,FirstName: firstName,  Image: image)
                        
                        friends2.append(friend)
                        print("ididididididid",id)
                        
                    }
                }

                self.data = friends2
                

            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
     

        NavigationView{
            VStack{
                Text("Friends").font(.largeTitle)
                    .padding(.top,140)
                    .foregroundColor(.red)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .bold()
               
               
                VStack(){
                    Spacer()
                    ForEach(data) { friend in
                        ContactRow2( login: login, data:friend)
                    }
                    
                   .listStyle(PlainListStyle())
                    .background(Color.clear)
                }//HStack
            }.padding(.bottom , 400)
                
            .background(Image("login").padding(.top, 0))//VStack
        }//NavigationView
        .onAppear {
            getUserId(login :login) { returnedid ,error in
                if let error = error {
                    print("el error " , data)
                }else{
                    print("el s7i7 " , data)
                    getFriendList(userId:returnedid! )}
               
            }
           
            // Dismiss the current sheet if any
            self.presentationMode.wrappedValue.dismiss()
        }
    }
     
}

 
struct FriendsList2_Previews: PreviewProvider {
    static var previews: some View {
        
        FriendsList2(login: "")
    }
}

struct ContactRow2: View {
 
    @State private var navigationLinkIsActive = false
    
    let login: String

    let data: Friend2
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
            
                
                        URLImage(URL(string: data.Image)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(50)
                        }
                    
                   
                    
                    ZStack {
                        
                        VStack(alignment: .leading) {
                            Text(data.FirstName)
                                .font(.system(size: 21, weight: .medium, design: .default))
                            
                        }
                    }
                }.padding(.horizontal , -170)
            }
          
        }
        }
    

struct Friend2:  Identifiable, Codable  {
    let id: String
     
     
    
    let FirstName: String
   
    let Image: String
}

