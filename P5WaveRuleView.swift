import SwiftUI
import Combine

struct WaveRuleView: View {
    private let images = ["beta4", "beta3", "beta2", "beta1"]
    
    @State private var currentIndex = 0
    @State private var timerSubscription: Cancellable? = nil
    var body: some View {
        NavigationStack {
            
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Group {
                            Text("Sail through Beta Waves")
                            
                            Text("Navigate the river of Brain waves to reach the elusive Computer Cave. Achieve a score of 10 to unlock this mysterious destination")
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
                            Text("Instruction")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Focus on identifying the Beta wave signals. Click on them to sail. Each correct selection boosts your score, moving you closer to the Computer Cave.")
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Group {
                            Text("Relevance with BCI")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("These represent sudden spikes of distict wave patterns, mimicks the real brainwave signals.")
                                .padding()
                                .background(Color.brown.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Group {
                            Text("Beta waves are 12 HZ - 30 HZ")
                                .font(.title2)
                                .fontWeight(.bold)
                            HStack {
                                Spacer()
                                Image(images[currentIndex])
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300, height: 360)
                                Spacer()
                            }
                            .padding([.top, .bottom])
                            .onAppear {
                                
                                timerSubscription = Timer.publish(every: 0.6, on: .main, in: .common)
                                    .autoconnect()
                                    .sink { _ in
                                        
                                        currentIndex = (currentIndex + 1) % images.count
                                    }
                            }
                            .onDisappear {
                                
                                timerSubscription?.cancel()
                            }
                        }
                        .padding(.horizontal, 20)
                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.horizontal, 20)
                .navigationTitle("Let's Go! Monitor the Beta Waves")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: GameView()) {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
        }

    }
}

struct WaveRuleView_Previews: PreviewProvider {
    static var previews: some View {
        WaveRuleView()
    }
}


