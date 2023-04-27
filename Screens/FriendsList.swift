//  FriendsList.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 26/4/2023.
//
 
import SwiftUI
import URLImage







struct FriendsList: View {
    
    let login: String
    @State var data = [Friend]()

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
        let url = URL(string: "http://localhost:9090/matche/amie/\(userId)")!
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
             
                var friends: [Friend] = []

                jsonArray.forEach { dict in
                    
                    if
                         let id = dict["id"] as? String,
            
                            let firstName = dict["FirstName"] as? String,
                            let image = dict["Image"] as? String {
                      
                        let friend = Friend(id: id,FirstName: firstName,  Image: image)
                        
                        friends.append(friend)
                        print("ididididididid",id)
                        
                    }
                }

                self.data = friends
                

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
                        ContactRow(login: login, data: friend)
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

 
struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        
        FriendsList(login: "")
    }
}
func getRomeName(user1: String, user2: String, completion: @escaping (String?, Error?) -> Void) {
        let url = URL(string: "http://127.0.0.1:9090/matche/rome/\(user1)/\(user2)")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    print("datadatadatadata",url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("datadatadatadata",data)
                completion(nil, error)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print ("jsonjsonjsonjson",json)
                if let rommeName = json["RommeName"] as? String {
                    print("romeNameromeName",rommeName)
                    completion(rommeName, nil)
                    print("jsonjsonjsonVjson",json)
                    // Do something with the rommeName
                  }
               
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
func getUserId1(login : String , completion: @escaping (String?, Error?) -> Void) {
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
            if let returnedid1 = responseJSON["value"] as? String {
                completion(returnedid1, nil)
            } else {
                print  ("Invalid response")
                completion(nil, NSError(domain: "com.yourapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
            }
        } else {
            print("Invalid JSON data")
            completion(nil, NSError(domain: "com.yourapp", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON data"]))
        }
       
    }.resume()
}
struct ContactRow: View {
    
    @State private var navigationLinkIsActive = false
    @State var romeName: String = ""
    let login: String

    let data: Friend
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    
                    
                    Button(action: {
                       
                        getUserId1(login :login) { returnedid1 ,error in
                                if let error = error {
                                    print("el error " , data)
                                }else{
                                    print("[[[[[[[el s7i7]]]]]]] " , data)
                                    getRomeName(user1: returnedid1! , user2: data.id) { name, error in
                                           if let name = name {
                                               self.romeName = name
                                               print ("namenamenamenamenamenamename",romeName)
                                             navigationLinkIsActive = true // Set navigation link active
                                           } else {
                                               self.romeName = "Error: \(error?.localizedDescription ?? "Unknown error")"
                                           }
                                       }}
                               
                            }
                           
                            // Dismiss the current sheet if any
                          
                      
                        // Navigate to chats screen
                    navigationLinkIsActive = true
                    }) {
                        URLImage(URL(string: data.Image)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(50)
                        }
                    }
                   
                    
                    ZStack {
                        
                        VStack(alignment: .leading) {
                            Text(data.FirstName)
                                .font(.system(size: 21, weight: .medium, design: .default))
                            
                        }
                    }
                }.padding(.horizontal , -170)
            }
        }.background(NavigationLink(destination: chats(), isActive: $navigationLinkIsActive) { EmptyView() })
           
        }
    }

struct Friend:  Identifiable, Codable  {
    let id: String
     
     
    
    let FirstName: String
   
    let Image: String
}

