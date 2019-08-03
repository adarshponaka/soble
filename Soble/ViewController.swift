import UIKit

class ViewController: UIViewController {
  
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    
    
    
    
    let randomDouble = Double.random(in: 1.0...6.0)
    
    print(randomDouble)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()  + 3) {
      
      self.performSegue(withIdentifier: "nextPage", sender: nil)
      
    }
    
    
    
  }
  
  
  
  
  
}

