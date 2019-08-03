import UIKit



class GameView: UIViewController {
  
  
  
  weak var timer: Timer?
  
  var startTime: Double = 0
  
  var time: Double = 0
  
  var elapsed: Double = 0
  
  var status: Bool = false
  
  override func viewDidLoad() {
    
    
    
    
    
    super.viewDidLoad()
    
    start()
    
    
    
    let button:UIButton = UIButton(frame: CGRect(x: Int.random(in: 20..<370), y: Int.random(in: 60..<732), width: 100, height: 50))
    
    button.backgroundColor = .black
    
    button.setTitle("Button", for: .normal)
    
    button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
    
    self.view.addSubview(button)
    
    
    
    let buttonfake:UIButton = UIButton(frame: CGRect(x: Int.random(in: 20..<370), y: Int.random(in: 60..<732), width: 100, height: 50))
    
    buttonfake.backgroundColor = .darkGray
    
    buttonfake.setTitle("Button", for: .normal)
    
    buttonfake.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
    
    self.view.addSubview(buttonfake)
    
    
    
    let buttonfake2:UIButton = UIButton(frame: CGRect(x: Int.random(in: 20..<370), y: Int.random(in: 60..<732), width: 100, height: 50))
    
    buttonfake2.backgroundColor = .darkGray
    
    buttonfake2.setTitle("Button", for: .normal)
    
    buttonfake2.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
    
    self.view.addSubview(buttonfake2)
    
    
    
  }
  
  
  
  @objc func buttonClicked() {
    
    stop();
    
  }
  
  
  
  @IBOutlet weak var reactionLabel: UILabel!
  
  
  
  @IBOutlet weak var reactionLabelSec: UILabel!
  
  @IBAction func gameButton(_ sender: Any) {
    
    
    
    stop();
    
  }
  
  
  
  func start() {
    
    startTime = Date().timeIntervalSinceReferenceDate - elapsed
    
    timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    
    
    
    // Set Start/Stop button to true
    
    status = true
    
    
    
  }
  
  
  
  func stop() {
    
    
    
    elapsed = Date().timeIntervalSinceReferenceDate - startTime
    
    timer?.invalidate()
    
    
    
    // Set Start/Stop button to false
    
    status = false
    
    var secs = Int(reactionLabelSec.text ?? "")!
                    var millis = Int(reactionLabel.text ?? "")!
                    
                    let t = Double(secs) + (0.001 * Double(millis))
                    
                    if (t > 1.03){
                              let alertController = UIAlertController(title: "Intoxication Test Failed", message:
                                        "You are still unfit to drive, please do not attempt to drive and continue to the next page.", preferredStyle: .alert)
                              alertController.addAction(UIAlertAction(title: "Continue", style: .default))
                                                        self.performSegue(withIdentifier: "uberSegue", sender: nil)

                              self.present(alertController, animated: true, completion: nil)

                      } else {
                              let alertController = UIAlertController(title: "Intoxication Test Passed", message:
                                        "You may drive, your car is now unlocked.", preferredStyle: .alert)
                              alertController.addAction(UIAlertAction(title: "Great!", style: .default))
                              
                                                                                                                          self.performSegue(withIdentifier: "top", sender: nil)

      self.present(alertController, animated: true, completion: nil)
                      }
    
    
  }
  
  
  
  @objc func updateCounter() {
    
    
    
    // Calculate total time since timer started in seconds
    
    time = Date().timeIntervalSinceReferenceDate - startTime
    
    
    
    // Calculate minutes
    
    let minutes = UInt8(time / 60.0)
    
    time -= (TimeInterval(minutes) * 60)
    
    
    
    // Calculate seconds
    
    let seconds = UInt8(time)
    
    time -= TimeInterval(seconds)
    
    
    
    // Calculate milliseconds
    
    let milliseconds = UInt8(time * 100)
    
    
    
    // Format time vars with leading zero
    
    let strMinutes = String(format: "%02d", minutes)
    
    let strSeconds = String(format: "%02d", seconds)
    
    let strMilliseconds = String(format: "%02d", milliseconds)
    
    
    
    // Add time vars to relevant labels
    
    reactionLabelSec.text = strSeconds
    
    reactionLabel.text = strMilliseconds
    
    
    
  }
  
  

    
}
