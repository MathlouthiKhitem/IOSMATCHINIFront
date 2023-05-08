//
//  matche.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 15/3/2023.
//


import SwiftUI
import URLImage

struct matche: View {
    let login: String
    var body: some View {
//        Text("login: \(login)")
        let homee =  Home( login: login)
        Home( login: login)
        
        
    }   
}


struct Home : View {
    @GestureState private var translation: CGSize = .zero
    @State private var isLiked = false
    @State private var isGestureEnabled = true
    @State private var isActive: Bool = false


    @State var x : CGFloat = 0
    @State var idDict : Int = 0
    @State var FirstNameDict : String = ""
    @State var AgeDict : Int = 0
    @State var loginDict : String = ""
    @State var ImageDict : String = ""
    @State var count : CGFloat = 0
    @State var screen = UIScreen.main.bounds.width - 30
    @State var op : CGFloat = 0
    @State var thi : Int = 0
    @State var currentIndex : Int = 0
    @State var  currentlogin : String = ""
    @State private var isProfileViewActive = false
    @State private var isFrinedViewActive = false
    @State var navigationSelection: String? = nil
    @State var navigationSelection1: String? = nil
    let login: String
    @State var userList = [User]()
    @State var data = [User]()
    func getId(login : String , completion: @escaping (String?, Error?) -> Void) {
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
                if let id = responseJSON["value"] as? String {
                    completion(id, nil)
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

    func matches(id1 : String , id2 : String){
        let url = URL(string: "http://localhost:9090/matche/matches/\(id1)/\(id2)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
          "User1_param": id1,
          "User2_param": id2
        ]
       

        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data, error == nil else {
         
            return
          }

          do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
          
          } catch {
            print("Error: \(error.localizedDescription)")
          }
        }

        task.resume()

    }
    func getUsers(completion: @escaping ([User]?) -> Void) {
        let url = URL(string: "http://localhost:9090/user/getUser")!
    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "login": login,
        ]

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
                var users = [User]()
                
                jsonArray.forEach { dict in
                   
                    if   let login = dict["login"] as? String,
                         let firstName = dict["FirstName"] as? String,
                    let age = dict["Age"] as? Int,
                    let image = dict["Image"] as? String,
                    let id = dict["id"] as? String
                    
                        
                         {
                        let user = User(id: id, login: login,FirstName:firstName,Age: age, Image: image, show: true)
                      
                            users.append(user)
                        
                       
                    }
                    
                }

                // Update the outer users array
                self.data = users
                self.op = ((self.screen + 15) * CGFloat(self.data.count / 2)) - (self.data.count % 2 == 0 ? ((self.screen + 15) / 2) : 0)
//                    if self.data.count > 0 {
           
                if self.data.count > 0 {
                    self.data[0].show = true
    

                }
              
              
                completion(users)
              
            } catch {
                // Handle error parsing JSON
            }
        }
        task.resume()
       
       
    }
    
    var body : some View{

        NavigationView{

            VStack{

                Spacer()


                HStack(spacing: 15){

                    ForEach(data){i in

                        CardView(home :  Binding.constant(Home(login: login)),currentIndex:currentIndex, data: i)
                            .offset(x: self.x)
                        
                            .highPriorityGesture(DragGesture()
                                .updating(self.$translation) { value, state, _ in
                                                                        state = value.translation
                                                                    }
                                .onChanged({ value in
                                    if value.translation.width < 0 {
                                        self.x = value.location.x - self.screen
                                    }
                                })
                                    .onEnded({ (value) in
                                                                       

                                                                           if value.translation.width > 0 && value.translation.width > ((self.screen - 80) / 2) && Int(self.count) != 0 {
                                                                               self.count -= 1
                                                                               self.updateHeight(value: Int(self.count))
                                                                               self.x = -((self.screen + 15) * self.count)
                                                                           }
                                                                           
                                                                          
                                                                          
                                                                           currentIndex = currentIndex+1
                                                                       })
                            )
                    }
                }
                
                .frame(width: UIScreen.main.bounds.width)
                .offset(x: self.op)

                Spacer()
            }.background(Image("background"))
                .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.bottom))
                .onAppear {
                    getUsers { loginUser2 in
             if let loginUser2 = loginUser2 {
                        } else {
                            print("No users found.")
                        }
                    }
                }
            
                .toolbar {
                   
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack (spacing: 70){
                            Button(action: {
                                self.isProfileViewActive = true
                                navigationSelection = login
                                
                            }) {
                                Image(systemName: "person")
                                    .bold()
                                    .font(.system(size: 25))
                                    
                                    
                                
                            }
                            
                            Button(action: {
                                // self.isProfileViewActive = true
                            }) {
                                Image(systemName: "house")
                                    .bold()
                                    .font(.system(size: 25))
                            }
                           
                            Button(action: {
                                self.isFrinedViewActive = true
                           
                                
                            }) {
                                Image(systemName: "message")
                                    .bold()
                                    .font(.system(size: 25))
                                
                                
                            }
                          
                        }
                        .padding(.horizontal, 20)
//                        .background(Color.white)
//                        .shadow(radius: 20)
//                            .opacity(1)
//                            .cornerRadius(50)
//                            .frame(width: 80, height: 50)
                        
                    }

                }
                .padding(.horizontal, 20)
                
            

                .sheet(isPresented: $isProfileViewActive) {
                    Profile(login:login)
                    NavigationLink(destination: Profile(login: login), tag: login, selection: $navigationSelection) {
                        EmptyView()
                    }
                }
               
                   
                .background(NavigationLink(destination: FriendsList(login: login, selectedTab: Tab.friends, tokenout: ""), isActive: $isFrinedViewActive) { EmptyView() })

               
        }.navigationBarBackButtonHidden(true)
        
                    .accentColor(Color.white)
                   // .background(Color.green)
    }
    
    

    func updateHeight(value : Int){


        for i in 0..<data.count{

            data[i].show = false
        }

        data[value].show = true
       
    }
}

struct CardView : View {
   
    @Binding var home: Home
    @State private var isLiked = false
    @State private var isShowingHeart = false
    let currentIndex : Int ;
    var data : User

    var body : some View{

        VStack(alignment: .leading, spacing: 0){
          
       
            
            URLImage(URL(string: data.Image)!) { image in
                image
                    .resizable()
                    //.aspectRatio(contentMode: .fit)
                    .shadow(radius:20)
                    .cornerRadius(50)
                    .frame(width: 500, height: 700)
                    
                    .overlay(
                                       ZStack {
                                           if isShowingHeart {
                                               Image(systemName: "heart.fill")
                                                   .resizable()
                                                   .foregroundColor(.pink)
                                                   .frame(width: 100, height: 100)
                                           }
                                       }
                                   )
                  
                    .onTapGesture(count: 2) {
                      
                        print(">>>>>>>>>" , currentIndex)
                        home.getUsers { loginUser2 in
                            if let loginUser2 = loginUser2 {
                                home.getId(login : home.login) { id, error in
                                    if let error = error {
                                    } else if let id = id {
                                        home.getId(login : loginUser2[currentIndex].login) { id2, error in
                                            if let error = error {
                                            } else
                                            if let id2 = id2 {

                                                home.matches(id1:id  , id2:id2  )
                                            }
                                        }
                                    }
                                }
                            } else {
                                print("No users found.")
                            }
                        }
                                       isLiked.toggle()
                                       isShowingHeart = true
                                       DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                           isShowingHeart = false
                                       }
                                   }

            }
           
            .frame(width: 500, height: 500)
            HStack {
                Text(data.FirstName)
                    .fontWeight(.semibold)
                    //.padding(.leading)
                    .padding(.horizontal, 90)
                    .foregroundColor(Color.white)
                    .font(.system(size: 25))
          
                    
                
                Spacer()

                Text(String(data.Age))
                    .fontWeight(.semibold)
                    // .padding(.trailing)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, -140)
                    .font(.system(size: 20))
                  
            }

            .padding(.horizontal, 20)
                        
                    }
       
        .frame(width: UIScreen.main.bounds.width - 30, height: 600)
        .background(Color.white)
        .cornerRadius(25)
        .padding(.top,40)
       

    }
    

}

struct Card : Identifiable {

    var id : Int
    var img : String
    var name : String
    var show : Bool
}
struct User: Identifiable, Codable {
    var id: String
    // Define a User model conforming to Codable
    let login: String
   let FirstName: String
    let Age : Int
    let Image : String
    var show : Bool
    // Add more properties as needed
}




struct matche_Previews: PreviewProvider {
    static var previews: some View {
        matche(login: "")
    }
}
