import SwiftUI
import SpriteKit

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let bubble: UInt32 = 0b1       
    static let shot: UInt32 = 0b10        
    static let shelf: UInt32 = 0b100
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var shooter = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50)) 
    let shelfWidth: CGFloat = 100.0
    let shelfHeight: CGFloat = 100.0
    let shelfSize: CGFloat = 100.0  
    let padding: CGFloat = 10.0 
    let totalShelves = 10
    var movingRight = true
    var score = 0 
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    var collectedItemsLabel = SKLabelNode(fontNamed: "Arial")
    var collectedItems: Set<ItemCategory> = []
    var collectedImages: Set<String> = []
    let redShelfImages = ["BI-img1", "BI-img2", "BI-img3", "BI-img4", "BI-img6"]
    let yellowShelfImages = ["BNI-img1", "BNI-img2", "BNI-img3", "BNI-img4", "BNI-img5"]
    var categoryLabels: [ItemCategory: SKLabelNode] = [:]
    let totalItemsPerCategory: [ItemCategory: Int] = [
        .eegHeadset: 1,
        .eyeTracker: 1,
        .faceReader: 1,
        .nonInvasiveSignalProcessor: 1,
        .nonInvasiveDevice: 1
    ]
    var collectedCountsByCategory: [ItemCategory: Int] = [
        .eegHeadset: 0,
        .eyeTracker: 0,
        .faceReader: 0,
        .nonInvasiveSignalProcessor: 0,
        .nonInvasiveDevice: 0
    ]
    
    enum ItemCategory: String {
        case eegHeadset = "EEG Headset"
        case eyeTracker = "Eye Tracker"
        case faceReader = "Face Reader"
        case nonInvasiveSignalProcessor = "Externnal Signal Processor"
        case nonInvasiveDevice = "Augmentive Communication Device"
        case invasiveEEG = "Invasive EEG"
        case invasiveSignalProcessor = "Invasive Signal Processor"
        case invasiveDevice = "Invasive Device"
    }
    
    let itemCategories: [String: ItemCategory] = [
        "BNI-img1": .eegHeadset, "BNI-img2": .eyeTracker, "BNI-img3": .faceReader,
        "BNI-img4": .nonInvasiveSignalProcessor,
        "BNI-img5": .nonInvasiveDevice,
        "BI-img1": .invasiveEEG, "BI-img2": .invasiveEEG, "BI-img3": .invasiveEEG,
        "BI-img4": .invasiveSignalProcessor,
        "BI-img6": .invasiveDevice 
    ]
    
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "caveInside")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = self.frame.size 
        background.zPosition = -1 
        addChild(background)
        
        backgroundColor = .black
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        let shooterTexture = SKTexture(imageNamed: "witharrow")
        shooter = SKSpriteNode(texture: shooterTexture, size: CGSize(width: 120, height: 120)) 
        shooter.position = CGPoint(x: frame.midX, y: shooter.size.height / 2 + 50)
        addChild(shooter)
        
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: self.frame.size.height - 90) 
        scoreLabel.horizontalAlignmentMode = .center
        addChild(scoreLabel)
        
        collectedItemsLabel.text = "Collected Non-Invasive components: "
        collectedItemsLabel.fontSize = 20
        collectedItemsLabel.fontColor = SKColor.white
        collectedItemsLabel.position = CGPoint(x: frame.midX, y: scoreLabel.position.y - 40) 
        collectedItemsLabel.horizontalAlignmentMode = .center
        collectedItemsLabel.zPosition = 10
        
        addChild(collectedItemsLabel)
        setupCategoryLabels()
        
        setupRevolvingShelves()
    }
    
    func setupCategoryLabels() {
        let categories = [
            ItemCategory.eegHeadset,
            ItemCategory.eyeTracker,
            ItemCategory.faceReader,
            ItemCategory.nonInvasiveSignalProcessor,
            ItemCategory.nonInvasiveDevice
        ]
        
        var yOffset: CGFloat = self.frame.size.height - 160 
        
        for category in categories {
            let label = SKLabelNode(fontNamed: "Arial")
            label.text = "\(category.rawValue): 0/\(totalItemsPerCategory[category] ?? 0)"
            label.fontSize = 15
            label.fontColor = SKColor.white
            label.horizontalAlignmentMode = .center
            label.position = CGPoint(x: frame.midX, y: yOffset)
            addChild(label)
            yOffset -= 30 
            
            categoryLabels[category] = label
        }
    }
    
    
    
    func setupRevolvingShelves() {
        
        var xPosition = CGFloat(0)
        
        
        for i in 0..<totalShelves {
            let isRedShelf = i % 2 == 0
            var texture = SKTexture()
            
            
            if isRedShelf{
                if i%2 == 0{
                    
                    texture = SKTexture(imageNamed: redShelfImages[i/2])
                    print(redShelfImages[i/2])
                }
                
            }
            else{
                
                texture = SKTexture(imageNamed: yellowShelfImages[(i-1)/2])
                print( yellowShelfImages[(i-1)/2])
            }
            let shelf = SKSpriteNode(texture: texture, size: CGSize(width: shelfSize, height: shelfSize))
            shelf.position = CGPoint(x: xPosition, y: self.frame.midY)
            xPosition += 110
            shelf.name = isRedShelf ? "redShelf" : "yellowShelf"
            
            shelf.physicsBody = SKPhysicsBody(rectangleOf: shelf.size)
            shelf.physicsBody?.isDynamic = false
            shelf.physicsBody?.categoryBitMask = PhysicsCategory.shelf
            shelf.physicsBody?.contactTestBitMask = PhysicsCategory.shot
            shelf.physicsBody?.collisionBitMask = PhysicsCategory.none
            
            addChild(shelf)
            
            
        }
        print("")
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        self.enumerateChildNodes(withName: "//*") { node, _ in
            if let shelf = node as? SKSpriteNode, shelf.name?.contains("Shelf") ?? false {
                
                let moveAmount: CGFloat = 2
                shelf.position.x += moveAmount
                
                
                if shelf.position.x > self.size.width + (self.shelfSize / 2) {
                    shelf.position.x = -self.shelfSize / 2
                    
                    
                    
                }
            }
        }
    } 
    
    var aimingLine: SKShapeNode?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        startAiming(from: shooter.position, to: location)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        updateAimingLine(to: location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, aimingLine != nil else { return }
        let location = touch.location(in: self)
        shoot(from: shooter.position, to: location)
        removeAimingLine()
    }
    
    func startAiming(from start: CGPoint, to end: CGPoint) {
        
        aimingLine?.removeFromParent()
        
        
        aimingLine = SKShapeNode()
        
        let deltaX = end.x - start.x
        let deltaY = end.y - start.y
        let length = sqrt(deltaX * deltaX + deltaY * deltaY)
        let dashLength: CGFloat = 10
        let gapLength: CGFloat = 5
        let numberOfDashes = Int(length / (dashLength + gapLength))
        
        for i in 0..<numberOfDashes {
            let dashNode = SKShapeNode(rectOf: CGSize(width: dashLength, height: 2))
            dashNode.fillColor = SKColor.white
            dashNode.strokeColor = SKColor.clear
            let angle = atan2(deltaY, deltaX)
            dashNode.zRotation = angle
            let dashPosition = CGFloat(i) * (dashLength + gapLength) + dashLength / 2
            dashNode.position = CGPoint(x: start.x + dashPosition * cos(angle), y: start.y + dashPosition * sin(angle))
            aimingLine?.addChild(dashNode)
        }
        
        if let aimingLine = aimingLine {
            addChild(aimingLine)
        }
    }
    
    func updateAimingLine(to location: CGPoint) {
        aimingLine?.removeFromParent() 
        startAiming(from: shooter.position, to: location) 
    }
    
    func removeAimingLine() {
        aimingLine?.removeFromParent()
        aimingLine = nil
    }
    
    func shoot(from start: CGPoint, to end: CGPoint) {
        let projectile = SKSpriteNode(color: .green, size: CGSize(width: 10, height: 10))
        projectile.position = start
        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.shot
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.shelf
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        
        let direction = CGVector(dx: end.x - start.x, dy: end.y - start.y)
        let shootAction = SKAction.move(by: direction, duration: 1)
        
        
        let removeAction = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([shootAction, removeAction]))
        
        addChild(projectile)
    }
    
    func updateCollectedItemsListUI() {
        for (category, label) in categoryLabels {
            let collectedCount = collectedCountsByCategory[category] ?? 0
            let totalCount = totalItemsPerCategory[category] ?? 0
            label.text = "\(category.rawValue): \(collectedCount)/\(totalCount)"
        }
    }
    func showCompletionPopup() {
        let popup = SKSpriteNode()
        popup.position = CGPoint(x: frame.midX, y: frame.midY)
        popup.zPosition = 10
        popup.alpha = 0.8
        popup.name = "completionPopup"
        
        let messageLabel = SKLabelNode(text: "Great! You collected all Non-invasive BCI components")
        messageLabel.fontName = "Arial"
        messageLabel.fontSize = 20
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: 0, y: 0)
        messageLabel.zPosition = 11
        popup.addChild(messageLabel)
        addChild(popup)
        
        
        let wait = SKAction.wait(forDuration: 5.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        popup.run(SKAction.sequence([wait, fadeOut, SKAction.removeFromParent()])) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { 
                self.transitionToEmotionView()
            }
        }
    }
    

    func transitionToEmotionView() {
        DispatchQueue.main.async {
            guard let window = self.view?.window else { return }
            let swiftUIView = emotionView() 
            let hostingController = UIHostingController(rootView: swiftUIView)
            
            
            UIView.transition(with: window, duration: 5.0, options: .transitionCrossDissolve, animations: {
                window.rootViewController = hostingController
            }, completion: nil)
        }
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.shelf | PhysicsCategory.shot {
            let shelfNode = contact.bodyA.categoryBitMask == PhysicsCategory.shelf ? contact.bodyA.node : contact.bodyB.node
            
            
            
            if let shelf = shelfNode as? SKSpriteNode,
               let imageName = shelf.texture?.description.valueFromQuotes(),
               let category = itemCategories[imageName] {
                let isNewCollection = collectedImages.insert(imageName).inserted
                if isNewCollection { 
                    collectedCountsByCategory[category, default: 0] += 1
                    updateCollectedItemsListUI()
                }
            }
            
            if let shelf = shelfNode as? SKSpriteNode {
                if shelf.name == "yellowShelf" {
                    
                    score += 1
                }  
                
                
                scoreLabel.text = "Score: \(score)"
                
                if score == 5 {
                    showCompletionPopup()
                    transitionToEmotionView()
                }
                
                
                shelf.removeFromParent()
                
                
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                
                
                updateCollectedItemsListUI()
                
            }
        }
    }
}



struct ShootView: View {
    var body: some View {
        ZStack {
            
            SpriteView(scene: configureScene())
                .frame(width: 1200, height: 1000) 
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                Text("Pull the arrow till targets to shoot. Collect all the items listed below.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.gray.opacity(0.5)) 
                    .frame(maxWidth: .infinity, alignment: .top)
                
                Spacer() 
            }
            .padding(.top) 
        }
    }

    
    private func configureScene() -> SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 1050, height: 900) 
        scene.scaleMode = .aspectFill
        return scene
    }
}


struct ShootView_Previews: PreviewProvider {
    static var previews: some View {
        ShootView()
    }
}


extension String {
    func valueFromQuotes() -> String? {
        
        let pattern = "'([^']*)'"
        
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }
        
       
        let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        
        
        if let match = matches.first {
            if let range = Range(match.range(at: 1), in: self) {
                return String(self[range])
            }
        }
        
        
        return nil
    }
}








