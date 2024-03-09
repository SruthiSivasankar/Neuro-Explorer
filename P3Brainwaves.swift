import SwiftUI

struct BrainWaveView: View {
    var body: some View {
        NavigationStack {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Group {
                        Text("The Brainwaves")
                        
                        Text("Let's Study Brainwaves to help Neuro-Explorer find the right resources for BCI")
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
                        Text("What is a Brain Wave?")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("A brain wave is an electrical impulse in the brain. It's the result of neurons communicating with each other, and it's fundamental to all our thoughts, emotions, and behaviors.")
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Group {
                        Text("Relationship with BCI")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Brain waves offer a non-invasive window into the brain's functioning, allowing BCI systems to decode user intentions without physical movements. This makes BCIs incredibly powerful tools for aiding individuals.")
                            .padding()
                            .background(Color.brown.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Group {
                        Text("Types of Brain Waves and Their BCI Applications")
                            .font(.title2)
                            .fontWeight(.bold)
                        HStack {
                            Spacer()
                            Image("brainwave") 
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 1000, height: 700)
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
                NavigationLink(destination: QuizView()) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
        
    }
}
struct BrainWaveView_Previews: PreviewProvider {
    static var previews: some View {
        BrainWaveView()
    }
}


