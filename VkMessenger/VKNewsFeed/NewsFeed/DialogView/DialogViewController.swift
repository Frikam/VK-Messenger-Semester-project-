import UIKit

protocol DialogViewModelWindow {
    var name : String { get }
    var photoUrlString: String { get }
}

class DialogViewController: UIViewController {
    let add = UIBarButtonItem(image: nil, style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = add
        // Do any additional setup after loading the view.
    }
    
    func set(name: String, photo: UIImageView) {
        self.navigationItem.title = name
        add.image = photo.image
        self.navigationItem.rightBarButtonItem = add
    }
}
