import SwiftUI

struct bciView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Group {
                            Text("Arrow Quest: Gather to Triumph")
                            
                            Text("Collect the System components (The hardware) to build BCI for Alex")
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
                            
                            Text("Shoot the arrows to Collect from revolving shelves. Shooting at right components for Communication BCI will earn you points")
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Group {
                            Text("Choose Non-Invasive BCI Components")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("A non-surgical BCI system can effectively capture and interpret brain using external sensors for communication")
                                .padding()
                                .background(Color.brown.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        Group {
                            Text("Key Components for Crafting a BCI System")
                                .font(.title2)
                                .fontWeight(.bold)
                            HStack {
                                Spacer()
                                Image("bciFlow") 
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 1000, height: 300)
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
                    NavigationLink(destination: ShootView()) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        
    }
}
struct bciView_Previews: PreviewProvider {
    static var previews: some View {
        bciView()
    }
}


