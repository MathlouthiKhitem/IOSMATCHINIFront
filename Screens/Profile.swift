//
//  Profile.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 15/3/2023.
//
//
//  Profile.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 15/3/2023.
//
import SwiftUI
import URLImage
struct Profile: View {
    let login: String
    var body: some View {
//        Text("test: \(login)")
        Profile1(login: login)
        
    }
}

struct Profile1: View {
    @State private var isProfileViewActive = false
    @State private var isProfileViewActive1 = false
    @State private var userImageURL: URL?
    @State private var userLogin: String = ""
    @State private var userAge: Int = 0
    @State private var userAgeString: Int = 0
    @State var navigationSelection: Bool = true
    let login: String
    var body: some View {
     

        NavigationView {
            VStack {
                if let imageURL = userImageURL {
                    URLImage(imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 250, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
                    .padding(.top, 130)
                } else {
                    ProgressView()
                        .padding(.top, 130)
                }

                Text(userLogin)
                    .font(.title).padding(.top, 30)

                Text(String(userAge) + " years Old")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding(.bottom, 50)

                Spacer()
            }.background(Image("login").padding(.top,40.0))
            
            .onAppear {
                fetchData()
            }
           
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        // Code for button action
                    }) {
                        Image(systemName: "gearshape")
                        Text("Setting")
                    }
                    Button(action: {
                        self.isProfileViewActive1 = true
                        NavigationLink(destination: EditProfile(login :login), isActive: $navigationSelection) { EmptyView()

                        }
                    }) {
                        Image(systemName: "person")
                        Text("Edit Profile")
                    }.accentColor(.red)
                        .background(Color.white)
                        .padding(.trailing)
                    .sheet(isPresented: $isProfileViewActive1) {
                        matchinii.EditProfile(login :login)
                        NavigationLink(destination: EditProfile(login :login), isActive: $navigationSelection) { EmptyView()

                        }
                    }
                   
                    Button(action: {
                        self.isProfileViewActive = true
                        let defaults = UserDefaults.standard
                        defaults.removeObject(forKey: "login")
                        defaults.removeObject(forKey: "id1")
                        defaults.removeObject(forKey: "id2")
                        defaults.removeObject(forKey: "paid")
                        NavigationLink(destination: matchinii.login(), isActive: $navigationSelection) { EmptyView()

                        }
                      
                        // Code for button action
                    }) {
                        Image(systemName: "power")
                        Text("Log Out")
                       
                        
                    } .accentColor(.red)
                        .background(Color.white)
                        .padding(.trailing)
                        .sheet(isPresented: $isProfileViewActive) {
                            matchinii.login()
                            NavigationLink(destination: matchinii.login(), isActive: $navigationSelection) { EmptyView()

                            }
                        }
                    Spacer()
                  
                    
                }
            } .accentColor(Color.red)
                .background(Color.red)
            
                
                
        }
    }

    func fetchData() {
        let url = URL(string: "http://localhost:9090/user/getOne/\(login)")!
print("......",url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["userId": ""]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                DispatchQueue.main.async {
                    if let imageUrlString = json?["Image"] as? String {
                        if let imageUrl = URL(string: imageUrlString) {
                            self.userImageURL = imageUrl
                        }
                    }
                    if let login = json?["login"] as? String {
                        self.userLogin = login
                    }
                    if let age = json?["Age"] as? Int {
                        self.userAge = age
                    }
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(login: "")
       
    }
}


//import SwiftUI
//
//struct Profile: View {
//
//    var body: some View {
//
//        NavigationView {
//
//            VStack {
//                Image("unnamed")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 150, height: 150)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                    .shadow(radius: 7)
//                    .padding(.top, 130)
//
//                Text("John Doe")
//                    .font(.title).padding(.top, 30)
//
//                Text("New York, USA")
//                    .foregroundColor(.gray)
//                    .font(.subheadline)
//                    .padding(.bottom, 50)
//
//                Spacer()
//            }.background(Image("login").padding(.top,40.0))
//
//
//
//                    .toolbar {
//
//
//                        ToolbarItemGroup(placement: .bottomBar) {
//                            Button(action: {
//                                // Code for button action
//                            }) {
//                                Image(systemName: "square.and.arrow.up")
//                                Text("Share")
//                            }
//                            Button(action: {
//                                // Code for button action
//                            }) {
//                                Image(systemName: "heart")
//                                Text("Like")
//                            }
//                            Spacer()
//                            Image(systemName: "person.crop.circle.fill")
//                                .resizable()
//                                .frame(width: 30, height: 30)
//                                .clipShape(Circle())
//
//                        }
//
//                    }
//
//            }
//    }
//}
//
//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile()
//    }
//}
