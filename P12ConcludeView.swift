import SwiftUI
import Combine

struct ConcludeView: View {
    private let images = ["alexEeg1", "alexEeg2"]
    @State private var currentIndex = 0
    @State private var imageTimerSubscription: Cancellable? = nil 
    @State private var displayedText = "" 
    private let fullText = "I'm so happy to be able to communicate again. Thank you !! Continue the journey where every thought has the power to transcend limitations and enrich lives. Your journey doesn't end here; it's just the beginning of a world where innovation and compassion intersects to create meaningful change." 
    @State private var textIndex = 0
    @State private var textTimerSubscription: Cancellable? = nil 
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {

                        Group {
                            Text("Congratulations!!")
                            
                            Text("Great Job! You have successfully escaped the labyrinth and built your first BCI. As our journey with Neuro-Explorer concludes, we carry forward a vision of hope and empowerment through BCI technology")
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
                            Text("Let's see what Alex wants to say:")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(displayedText)
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onAppear {
                                    textTimerSubscription = Timer.publish(every: 0.05, on: .main, in: .common) 
                                        .autoconnect()
                                        .sink { _ in
                                            if textIndex < fullText.count {
                                                let index = fullText.index(fullText.startIndex, offsetBy: textIndex)
                                                displayedText.append(fullText[index])
                                                textIndex += 1
                                            } else {
                                                textTimerSubscription?.cancel() 
                                            }
                                        }
                                }
                        }

                        HStack {
                            Spacer()
                            Image(images[currentIndex])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 500, height: 560)
                            Spacer()
                        }
                        .padding([.top, .bottom])
                        .onAppear {
                            imageTimerSubscription = Timer.publish(every: 0.6, on: .main, in: .common)
                                .autoconnect()
                                .sink { _ in
                                    currentIndex = (currentIndex + 1) % images.count
                                }
                        }
                        .onDisappear {
                            imageTimerSubscription?.cancel()
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: IntroPageView()) {
                        Text("Restart")
                    }
                }
            }
        }
    }
}

struct ConcludeView_Previews: PreviewProvider {
    static var previews: some View {
        ConcludeView()
    }
}




