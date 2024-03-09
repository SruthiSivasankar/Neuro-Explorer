import SwiftUI

struct emotionView: View {
    private let images = ["ai2", "ai1"]
    @State private var currentIndex = 0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Group {
                            Text("Train the Computer to Escape the Labyrinth")
                            
                            Text("Oops! You entered the Labyrinth. Meet your Computer Companion. Train him to escape with collected System components")
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
                        
                            Text("Instruction")
                                .font(.title2)
                                .fontWeight(.bold)
                                HStack {
                            
                            Text("Navigate through the labyrinth by clicking the directions buttons. Drag and match the brain signal with its relevant emotion to clear the obstacle. Successful escape demostrates collected BCI component's machine learning ability")
                                Spacer()
                        }
                                .padding()
                                .frame(maxWidth: .infinity) 
                                .background(Color.green.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                            }
                            .frame(maxWidth: .infinity) 
                            
                            Spacer() 
                            
                            Image(images[currentIndex])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .onReceive(timer) { _ in
                                    
                                    currentIndex = currentIndex == 0 ? 1 : 0
                                }                    
                        }
                        Group {
                            Text("Brain areas for communication")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Brain wave patterns in central celebral cortex which includes Broca's area, Wernicke's area and Primary Auditory Cortex are responsible for communication")
                                .padding()
                                .background(Color.brown.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Group {
                            Text("Brain Wave patterns and correlated emotions")
                                .font(.title2)
                                .fontWeight(.bold)
                            HStack {
                                Spacer()
                                Image("BrainEmotion") 
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 500, height: 600)
                                Spacer() 
                            }
                            .padding([.bottom])
                        }
                                           }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MazeView()) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        
    }
}
struct emotionView_Previews: PreviewProvider {
    static var previews: some View {
        emotionView()
    }
}


