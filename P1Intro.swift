import SwiftUI

struct IntroPageView: View {
    private let images = ["explorer-pose", "explorer-closedeye"]
    
    @State private var currentIndex = 0
    
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    var body: some View {
        NavigationStack {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Group {
                        Text("Neuro Explorer: A BCI Odyssey")
                        
                        Text("Welcome! Meet the intrepid Neuro-Explorer . Embark on a groundbreaking journey with him in harnessing the power of Brain-Computer Interface (BCI) technology. Lets make thoughts become actions.")
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing, .bottom])
                            .font(.title3)
                    }
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                    HStack(alignment: .top) { 
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("The Mission")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                        
                            HStack {
                                Text("Assist Neuro-Explorer in gathering critical resources and knowledge essential for pioneering BCI devices by navigating through diverse terrains of neural and computer network.")
                                Spacer() 
                            }
                            .padding()
                            .frame(maxWidth: .infinity) 
                            .background(Color.green.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text("The Levels")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            
                            HStack {
                                Text("Empowering Lives: Each level challenges you to tailor BCI solutions for individuals with unique needs, unlocking their potential to communicate, move, and interact with the world in new ways.")
                                Spacer() 
                            }
                            .padding()
                            .frame(maxWidth: .infinity) 
                            .background(Color.brown.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            
                        }
                        .frame(maxWidth: .infinity) 
                        
                        Spacer() 
                        
                        Image(images[currentIndex])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 500, height: 600)
                            .onReceive(timer) { _ in
                                
                                currentIndex = currentIndex == 0 ? 1 : 0
                            }                    
                    }
                    .padding()
                }
                .padding()
                
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: Level1View()) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
        
    }
}

struct IntroPageView_Previews: PreviewProvider {
    static var previews: some View {
        IntroPageView()
    }
}








