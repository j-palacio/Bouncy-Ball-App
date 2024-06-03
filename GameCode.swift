import Foundation

let ball = OvalShape(width: 40, height: 40)
var barriers: [Shape] = []
var targets: [Shape] = []

let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]

let funnel = PolygonShape(points: funnelPoints)

/*
 The setup() function is called once when the app launches. Without it, your app won't compile.
 Use it to set up and start your app.
 
 You can create as many other functions as you want, and declare variables and constants,
 at the top level of the file (outside any function). You can't write any other kind of code,
 for example if statements and for loops, at the top level; they have to be written inside
 of a function.
 */

fileprivate func setupBall() {
    ball.position = Point(x: 250, y: 400)
    scene.add(ball)
    ball.hasPhysics = true
    ball.fillColor = .blue
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
    ball.bounciness = 0.6
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    // Add a barrier to the scene.
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    
    let barrier = PolygonShape(points: barrierPoints)
    
    barriers.append(barrier)
    
    barrier.position = position
    barrier.hasPhysics = true
    scene.add(barrier)
    barrier.isImmobile = true
    barrier.fillColor = .brown
    barrier.angle = angle
}

fileprivate func setupFunnel() {
    // Add a funnel to the scene.
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    funnel.onTapped = dropBall
    funnel.fillColor = .gray
    funnel.isDraggable = false
}

func addTarget(at position: Point) {
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]
    
    let target = PolygonShape(points: targetPoints)
    
    targets.append(target)
    
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    scene.add(target)
    target.name = "target"
    target.isDraggable = false
}

func setup() {
    
    setupBall()
    
    addBarrier(at: Point(x: 197.33348083496094, y: 609.6668701171875), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 188.00001525878906, y: 441.6668395996094), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 79.99999237060547, y: 533.3334350585938), width: 30, height: 15, angle: -0.2)
    addBarrier(at: Point(x: 88.99998474121094, y: 354.00006103515625), width: 30, height: 15, angle: -0.2)
    
    setupFunnel()
    
    // Add a target to the scene.
    addTarget(at: Point(x: 201.66673278808594, y: 644.33349609375))
    addTarget(at: Point(x: 95.33330535888672, y: 560.3333740234375))
    addTarget(at: Point(x: 177.33334350585938, y: 472.3333435058594))
    addTarget(at: Point(x: 93.00003814697266, y: 381.3333740234375))
    addTarget(at: Point(x: 194.0000457763672, y: 239.99996948242188))
    
    resetGame()
    
    scene.onShapeMoved = printPosition(of:)
}


// Drops the ball by moving it to the funnel's position.
func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    
    for barrier in barriers {
        barrier.isDraggable = false
    }
    
    for target in targets {
        target.fillColor = .yellow
    }
}

// Handles collisions between the ball and the targets.
func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" { return }
    
    otherShape.fillColor = .green
}

func ballExitedScene() {
    for barrier in barriers {
        barrier.isDraggable = true
    }
    
    var hitTargets = 0
    for target in targets {
        if target.fillColor == .green {
            hitTargets += 1
        }
    }
    
    if hitTargets == targets.count {
        scene.presentAlert(text: "You won!", completion: alertDismissed)
    }
}

// Resets the game by moving the ball below the scene,
// which will unlock the barriers.
func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

func printPosition(of shape: Shape) {
    print(shape.position)
}

func alertDismissed() {
}
