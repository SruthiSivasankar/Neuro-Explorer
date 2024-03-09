import SwiftUI
import Combine

enum BrainwaveType: String, CaseIterable {
    case delta = "Delta", theta = "Theta", alpha = "Alpha", beta = "Beta", gamma = "Gamma"
    
    var color: Color {
        switch self {
        case .delta: return .blue
        case .theta: return .mint
        case .alpha: return .cyan
        case .beta: return .indigo
        case .gamma: return .blue
        }
    }
} 

struct VerticalWaveShape: Shape {
    let amplitude: CGFloat
    let wavelength: CGFloat
    var phase: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        
        for x in stride(from: 0, to: width, by: 1) {
            let y = amplitude * sin((x / wavelength) * 2 * .pi + phase) + rect.midY
            if x == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
    
    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
}


struct BrainwaveTile: Identifiable, Equatable {
    let id = UUID()
    var type: BrainwaveType
    var hasBeenTapped: Bool = false
}


struct BrainwaveTileView: View {
    var tile: BrainwaveTile
    var tapAction: () -> Void
    @State private var phase = 0.0
    
    private func waveProperties(for type: BrainwaveType) -> (amplitude: CGFloat, wavelength: CGFloat) {
        switch type {
        case .gamma:
            return (35, 15)
        case .beta:
            return (30, 30)
        case .alpha:
            return (25, 50)
        case .theta:
            return (15, 60)
        case .delta:
            return (10, 80)
        }
    }
    
    var body: some View {
        let properties = waveProperties(for: tile.type)
        
        
        Button(action: tapAction) {
            VerticalWaveShape(amplitude: properties.amplitude, wavelength: properties.wavelength, phase: phase)
                .stroke(tile.type.color, lineWidth: 5) 
                .rotationEffect(.degrees(90)) 
                .frame(width: 75, height: 150) 
                .background(Color.clear) 
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                phase += 2 * .pi
            }
        }
    }
}

struct VerticalProgressBar: View {
    var score: Int
    let maxScore: Int = 10 
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                
                Capsule()
                    .foregroundColor(.gray.opacity(0.2))
                    .frame(width: 10)
                
                
                Capsule()
                    .foregroundColor(.blue)
                    .frame(width: 10, height: min(CGFloat(score) / CGFloat(maxScore), 1.0) * geometry.size.height)
                    .animation(.easeInOut(duration: 0.2), value: score)
                
                
                Image("explorersurf") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100) 
                
                    .offset(x: -40, y: -(min(CGFloat(score) / CGFloat(maxScore), 1.0) * geometry.size.height) - 20)                    .animation(.easeInOut(duration: 0.2), value: score)
                
            }
            .frame(width: 20) 
        }
    }
}


// Game View
struct GameView: View {
    @State private var rows: [[BrainwaveTile]] = (0..<5).map { _ in
        BrainwaveType.allCases.shuffled().map { BrainwaveTile(type: $0) }
    }
    @State private var score: Int = 0
    @State private var gameIsOver: Bool = false
    let numberOfRows = 5 
    @State private var timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    @State private var timerSubscription: AnyCancellable?
    @State private var backgroundOffset = CGFloat(0)
    let backgroundMoveDistance: CGFloat = UIScreen.main.bounds.height*0.5
    @State private var showCaveView = false
    @State private var showHint = false
    //    let backgroundLoopDuration = 1.0
    //    let backgroundHeight = UIScreen.main.bounds.height * 2
    
    
    var body: some View {
            
            ZStack {
                Image("sea1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .offset(y: backgroundOffset)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Identify and Click on the Beta Waves to sail. Use Hint")
                        .foregroundColor(.white)
                        .padding()
                        .font(.system(size: 20)) 

                    Spacer()
                }
                .zIndex(1)
                HStack {
                    Spacer()
                    
                    // Waves
                    VStack(spacing: 10) {
                        Text("Score: \(score)")
                            .font(.title)
                            .padding()
                        
                        if gameIsOver {
                            Text("Game Over")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                                .padding()
                            Button("Restart") {
                                resetGame()
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        } else {
                            VStack(spacing: 10) {
                                ForEach(rows.indices, id: \.self) { rowIndex in
                                    HStack(spacing: 10) {
                                        ForEach(rows[rowIndex]) { tile in
                                            BrainwaveTileView(tile: tile) {
                                                tileTapped(tile)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.trailing, 40)
                    .frame(maxHeight: .infinity, alignment: .center) 
                    
                    // Vertical Progress Bar
                    VerticalProgressBar(score: score)
                        .frame(width: 20, height: CGFloat(numberOfRows) * 150 + CGFloat(numberOfRows - 1) * 10)
                        .padding(.leading, 20) 
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            
                            self.showHint.toggle()
                        }) {
                            Text("Hint")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.leading,40)
                        .position(x: UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.height - 100) 
                        
                        Spacer()
                    }
                    .padding() 
                }
                
                
                if showHint {
                    Image("betaHint") 
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200) 
            
                        .position(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height - 170) 
                    
                      
                        .onTapGesture {
                           
                            self.showHint = false
                        }
                    
                }
            }
            .onAppear {
                setupInitialRows()
                animateBackground()            
                timerSubscription = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect().sink { _ in
                    moveTiles()
                }
            }
            .fullScreenCover(isPresented: $showCaveView) {
                CaveView()
            }
            
        }
    private func animateBackground() {
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            withAnimation(.linear(duration: 0.02)) {
                self.backgroundOffset += 1
                if self.backgroundOffset >= self.backgroundMoveDistance {
                    self.backgroundOffset = 0
                }
            }
        }
        
    }
    
    
    private func setupInitialRows() {
        rows = (0..<numberOfRows).map { _ in BrainwaveType.allCases.shuffled().map { BrainwaveTile(type: $0) } }
    }
    
    private func moveTiles() {
        let newRow = BrainwaveType.allCases.shuffled().map { BrainwaveTile(type: $0) }
        withAnimation {
            rows.insert(newRow, at: 0)
            if rows.count > numberOfRows {
                rows.removeLast()
            }
        }
    }
    
    private func tileTapped(_ tile: BrainwaveTile) {
        if tile.type == .beta {
            score += 1
            if score == 10 { 
                showCaveView = true 
            }
        } else {
            gameIsOver = true
            timerSubscription?.cancel()
        }
    }
    
    private func resetGame() {
        score = 0
        gameIsOver = false
        setupInitialRows()
        timerSubscription?.cancel()
        timerSubscription = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect().sink { _ in
            moveTiles()
        }
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

