import SwiftUI

struct ContentVieww: View {
    
    @StateObject var viewModel = SubscriptionViewModel()
    
    var body: some View {
        
        VStack{
            
            if viewModel.errorMessage != nil {
                
                Text(viewModel.errorMessage ?? "")
                
            }else if viewModel.isSuccessPayment {
                
                Text("Payment Success Page!")
                
            } else{
                CheckoutView(viewModel: self.viewModel)
            }
            
        }.onAppear{
            
            self.viewModel.tokenization()
            
        }
        
    }
}

struct ContentVieww_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
