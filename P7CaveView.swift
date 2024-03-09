import SwiftUI
import SwiftUI

struct CaveView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Group {
                            Text("The Computer Cave")                                
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text("Congratulations!! You reached the mysterious Computer cave")
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.blue)
                                .padding([.leading, .trailing, .bottom])
                                .font(.title3)
                        }
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        
                        
                      
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Image("island")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all) 
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: bciView()) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        
    }
}
struct CaveView_Previews: PreviewProvider {
    static var previews: some View {
        CaveView()
    }
}
