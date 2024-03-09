import SwiftUI
import Combine

struct Level1View: View {
    private let images = ["Alex-pose", "Alex-closed"]
    @State private var currentIndex = 0
    @State private var timerSubscription: Cancellable? = nil
    var body: some View {
        NavigationStack {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Group {
                        Text("Level-1")
                        
                        Text("Meet Alex! He is a adventurer and a sports enthusiast. A skiing accident has left him unable to speak.")
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
                    
                    Group {
                        Text("The Task")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Help Alex communicate through a Brain Computer Interface. Travel to Computer caves to find resouces and build BCI for him")
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("Monitor 'Beta' BrainWaves which is associated with High focus, listening and alertness to develop Communication BCI system ")
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    HStack {
                        Spacer()
                        Image(images[currentIndex])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 400, height: 460)
                        Spacer()
                    }
                    .padding([.top, .bottom])
                    .onAppear {
                        
                        self.timerSubscription = Timer.publish(every: 0.6, on: .main, in: .common)
                            .autoconnect()
                            .sink { _ in
                                self.currentIndex = self.currentIndex == 0 ? 1 : 0
                            }
                    }
                    .onDisappear {
                       
                        self.timerSubscription?.cancel()
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: WaveRuleView()) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .overlay(
            VStack {
                Spacer() 
                HStack {
                    NavigationLink(destination: BrainWaveView()) {
                        Text("Learn about other Brainwaves and its Application")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue.opacity(1))
                            .cornerRadius(8)
                    }
                    Spacer() 
                }
                .padding() 
            }
        )
        }
    }
}
struct Level1View_Previews: PreviewProvider {
    static var previews: some View {
        Level1View()
    }
}



