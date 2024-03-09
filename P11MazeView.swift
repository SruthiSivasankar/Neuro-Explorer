import SwiftUI
import UniformTypeIdentifiers

struct MazeView: View {
    let maze = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1],
        [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
        [1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1],
        [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1],
        [1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1],
        [1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1],
        [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    ]
    @State private var humanPosition = (row: 10, column: 1) 
    let targetImages = ["HappyEmoji", "RelaxedEmoji", "SadEmoji", "AngryEmoji"]
    @State private var matchedImages: [String: Bool] = ["HappyEmoji": false, "RelaxedEmoji": false, "SadEmoji": false, "AngryEmoji": false]
    @State private var imagePositions: [String: (row: Int, column: Int)] = [
        "happyBrain": (3, 9), "calmBrain": (3, 16), "sadBrain": (5, 14), "angerBrain": (6, 11)
    ]
    let imageMatchMapping: [String: String] = [
        "HappyEmoji": "happyBrain",
        "RelaxedEmoji": "calmBrain",
        "SadEmoji": "sadBrain",
        "AngryEmoji": "angerBrain"
    ]
    @State private var showConclusionView = false
    @State private var showHint = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Text("Drag and match each brain wave pattern to its emotion. Click on navigation buttons below to move.")
                    .font(.headline)
                    .padding()
                    .multilineTextAlignment(.center)
                if showConclusionView {
                    ConcludeView() 
                } else {
                    Image("roboAndWave") 
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150) 
                        .padding()
                    HStack {
                        ForEach(targetImages, id: \.self) { imageName in
                            Image(imageName) 
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .border(matchedImages[imageName] == true ? Color.green : Color.gray, width: 2)
                                .onDrop(of: [UTType.text], isTargeted: nil) { providers in
                                    providers.first?.loadObject(ofClass: NSString.self) { (droppedItem, error) in
                                        DispatchQueue.main.async {
                                            if let droppedImageName = droppedItem as? String,
                                               let targetImageName = imageMatchMapping.first(where: { $1 == droppedImageName })?.key,
                                               targetImageName == imageName,
                                               matchedImages[targetImageName] == false {
                                                
                                                matchedImages[targetImageName] = true 
                                                imagePositions.removeValue(forKey: droppedImageName) 
                                            }
                                        }
                                    }
                                    return true
                                }
                            
                        }
                    }
                    .padding()
                    
                    
                    VStack(spacing: 0) {
                        
                        ForEach(0..<maze.count, id: \.self) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<maze[row].count, id: \.self) { column in
                                    Group {
                                        if row == humanPosition.row && column == humanPosition.column {
                                            Image("explorerTop") 
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 40) 
                                        } else if let imageName = imagePositions.first(where: { $0.value == (row, column) })?.key {
                                            Image(imageName).resizable().scaledToFit().frame(width: 40, height: 40)
                                                .onDrag {
                                                    return NSItemProvider(object: imageName as NSString)
                                                }
                                        } else {
                                            Rectangle().fill(maze[row][column] == 1 ? Color.brown : Color.clear).frame(width: 40, height: 40)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    .border(Color.black, width: 2)
                    
                    
                    
                    
                    VStack {
                        Button("Up") {
                            moveHuman(in: .up) }
                        HStack {
                            Button("Left") { moveHuman(in: .left) }
                            Spacer().frame(width: 60)
                            Button("Right") { moveHuman(in: .right) }
                        }
                        Button("Down") { moveHuman(in: .down) }
                    }
                    
                    
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
                        
                        Spacer() 
                    }
                    .padding(.bottom) 
                }
            }
            
            if showHint {
                
                Image("emotionWave") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top,450) 
                    .padding(.leading, 40) 
                    .transition(.opacity) 
                    .onTapGesture {
                        
                        self.showHint = false
                    }
            }
            
        }
    }
    
    func moveHuman(in direction: Direction) {
        let newPosition: (row: Int, column: Int)
        switch direction {
        case .up:
            newPosition = (humanPosition.row - 1, humanPosition.column)
        case .down:
            newPosition = (humanPosition.row + 1, humanPosition.column)
        case .left:
            newPosition = (humanPosition.row, humanPosition.column - 1)
        case .right:
            newPosition = (humanPosition.row, humanPosition.column + 1)
        }
        
        
        if newPosition.row >= 0, newPosition.row < maze.count,
           newPosition.column >= 0, newPosition.column < maze[0].count,
           maze[newPosition.row][newPosition.column] == 0 {
            
            
            let isPathBlocked = imagePositions.values.contains(where: { $0 == newPosition })
            
            if !isPathBlocked {
                humanPosition = newPosition
                
                if newPosition == (3, 19) {
                    showConclusionView = true
                    showHint = false
                }
            }
        }
    }
    
    
    enum Direction {
        case up, down, left, right
    }
}

struct MazeView_Previews: PreviewProvider {
    static var previews: some View {
        MazeView()
    }
}






