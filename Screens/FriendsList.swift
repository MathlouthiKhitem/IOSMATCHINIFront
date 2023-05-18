//  FriendsList.swift
//  matchinii
//
//  Created by Khitem Mathlouthi on 26/4/2023.
//
 
import SwiftUI
import URLImage
import Foundation



import SocketIO



enum Tab {
       case friends
       case messages
       case settings
   }


struct FriendsList: View {
    @State private var showNextView = false

//    @State private var selectedTab: Tab = .friends
    @State private var selectedTab: Tab
    @State private var friends: [Friend] = []
    @State private var messages: [Friend] = []
   @State private var settings: [Friend] = []
    let login: String
    @State private var selection = false
    @State private var validPaiement = false
    @State var data = [Friend]()
    @State var data1 = [Friend]()
    @State var data2 = [Friend]()
    let defaults = UserDefaults.standard


    @State var amount: Double = 220.25
    @State var note: String = "Order #123"
    @State var firstName: String = "Rahma"
    @State var lastName: String = "Tiss"
    @State var email: String = "rahma.tiss@esprit.tn"
    @State var phone: String = "+21624188250"
    @State var returnUrl: String = "https://www.return_url.tn"
    @State var cancelUrl: String = "https://www.cancel_url.tn"
    @State var webhookUrl: String = "https://www.webhook_url.tn"
    @State var orderId: String = "244557"
   
   
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
                print("kkkkk",jsonArray)
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

                self.data = friends
                

            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }




    func getYourMatches(userId: String) {
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
                print("getYourMatchesgetYourMatches",jsonArray)
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
                print("data1data1data1data1data1",data1)


            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    func getTopmatches(userId: String) {
        let url = URL(string: "http://localhost:9090/matche/notamieeee/\(userId)")!
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
                print("getYourMatchesgetYourMatches",jsonArray)
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

                self.data2 = friends
                print("data1data1data1data1data1",data2)


            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }



    @Environment(\.presentationMode) var presentationMode
    init(login: String, selectedTab: Tab ) {
          self.login = login
          _selectedTab = State(initialValue: selectedTab)
       
      }
    
    var body: some View {
      
        @State var isDialogVisible = false
            

        NavigationView{
          
                     
           
            VStack{
                Text("Friends").font(.largeTitle)
                    .padding(.top,100)
                    .foregroundColor(.red)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .bold()
             
                          
               

               
                Picker(selection: $selectedTab, label: Text("Segmented Control")) {
                    Text("Friends").tag(Tab.friends)
                    Text("Your matches").tag(Tab.messages)
                    Text("Top matches").tag(Tab.settings)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top , -150)
                .background(Color.white)
              
                switch selectedTab {
                case .friends:
                    
                    VStack {
                        Spacer()
                        ForEach(data) { friend in
                            ContactRow(login: login, data: friend)
                            
                            Spacer()
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                case .messages:
                    VStack {
                        Spacer()
                       
                        ForEach(data1) { friend in
                            NavigationLink(destination: matchinii.login()) {

                                      YourMatchesRow(login: login, data1: friend)
                                  }
                                  Spacer()
                              }
                        
                        .listStyle(PlainListStyle())
                        .background(Color.clear)

                      
                    }
                    if (defaults.object(forKey: "paid") != nil) != true {
                        Button(action: {
                            
                        }, label: {
                            NavigationLink(destination: CheckoutViewControllerWrapper(login : login)) {
                                Text("Payer \(amount) TND")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(10)
                                
                            }
                            
                        })
                    }else {
                        VStack {
                            Spacer()
                            ForEach(data1) { friend in
                        
                                          YourMatchesRow(login: login, data1: friend)

                                     
                                  }                            .listStyle(PlainListStyle())
                            .background(Color.clear)
                        }
                        
                    }
                case .settings:
                    VStack {
                        Spacer()
                        ForEach(data2) { friend in

                            TOPMatchesRow(login: login, data2: friend)
                            Spacer()
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }                }
               
               
//                VStack(){
//                    Spacer()
//                    ForEach(data) { friend in
//                        ContactRow(login: login, data: friend)
//                    }
//
//                   .listStyle(PlainListStyle())
//                    .background(Color.clear)
//                }//HStack
            }.padding(.bottom , 400)
                
            .background(Image("login").padding(.top,-50 ))//VStack
        }//NavigationView
        .onAppear {
            getUserId(login :login) { returnedid ,error in
                if let error = error {
                    print("el error " , data)
                   
                }   else if let userId = returnedid {
                    getFriendList(userId: userId)
                    getYourMatches(userId: userId)
                    getTopmatches(userId: userId)
                
                  //  createPayment()
                    
                }
            }
           
            // Dismiss the current sheet if any
            self.presentationMode.wrappedValue.dismiss()
        }
        
    }
     
}

 
struct FriendsList_Previews: PreviewProvider {
    static var previews: some View {
        
        FriendsList(login: "", selectedTab: Tab.messages)
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
    @State var userName: String = ""

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
                         userName=login
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
                           
                            Text(data.LasteName)
                                .font(.system(size: 10, weight: .medium, design: .default))
                                .foregroundColor(.red)
                        }
                    }
                }.padding(.horizontal , -170)
            }
        }.background(NavigationLink(destination: chats(webSocketManager:WebSocketManager( socketURL: URL(string: "ws://127.0.0.1:3000")!), userName:userName, roomName:romeName), isActive: $navigationLinkIsActive) { EmptyView() })
           
        }
    }
struct YourMatchesRow: View {
    
    @State private var navigationLinkIsActive = false
    @State var romeName: String = ""
    let login: String

    let data1: Friend
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
                    
                    Spacer()
                
                   
                    
                    ZStack {
                        
                        VStack(alignment: .leading) {
                            Text(data1.FirstName)
                                .font(.system(size: 21, weight: .medium, design: .default))
                           
                            Text(data1.LasteName)
                                .font(.system(size: 10, weight: .medium, design: .default))
                                .foregroundColor(.red)
                        }
                    }
                   

                }.padding(.horizontal , -170)
            }
        }
           
        }
    }

struct TOPMatchesRow: View {
    
    @State private var navigationLinkIsActive = false
    @State var romeName: String = ""
    let login: String

    let data2: Friend
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                
                HStack {
               
                     
                        URLImage(URL(string: data2.Image)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(50)
                        }
                    
                   
                    
                    ZStack {
                        
                        VStack(alignment: .leading) {
                            Text(data2.FirstName)
                                .font(.system(size: 21, weight: .medium, design: .default))
                           
                            Text(data2.LasteName)
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
struct Friend:  Identifiable, Codable  {
    let id: String
    let FirstName: String
    let Image: String
    let LasteName: String
}

     

    






