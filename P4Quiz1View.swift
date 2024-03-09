import SwiftUI

struct QuizView: View {
    @State private var showWrongAnswerMessage = false 
    
    
    struct GradientButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .foregroundColor(.black)
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(10)
                .font(.headline)
                .frame(width: 500)
        }
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    Text("Quiz Time")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Which Brain wave should be monitored to help Neuro-Explorer build 'Communication BCI'?")
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
                
                
                ForEach(["Delta", "Theta", "Alpha", "Beta", "Gamma"], id: \.self) { option in
                    Group {
                        if option == "Beta" {
                            
                            NavigationLink( destination: WaveRuleView()) {
                                Text(option)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(GradientButtonStyle())
                            .padding(.horizontal)
                        } else {
                            Button(action: {
                                
                                showWrongAnswerMessage = true
                            }) {
                                Text(option) 
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(GradientButtonStyle())
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: 50) 
                }
                
                if showWrongAnswerMessage {
                    Text("Oops! Wrong answer. Let's go back to study Brain Waves?")
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
        }
        .onChange(of: showWrongAnswerMessage) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showWrongAnswerMessage = false
                }
            }
        }
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}



