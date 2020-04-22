
import UIKit

class CollectionViewController: UICollectionViewController{
    //flow layout to set spacing
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // load memes struct from appDelegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //configure layout
        configureLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //reload data to refresh collection view
        self.collectionView.reloadData()
    }
    func configureLayout(){
        //create new meme button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createMeme))
        //set spacing
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    //move to create new meme view
    @objc func createMeme(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeCreationViewController") as! MemeCreationViewController
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    //set number of table cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    //populate collection view
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as! MemeCollectionCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImage.image = meme.memedImage
        cell.label.text = meme.topText
        return cell
    }
    //show meme
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = self.memes[(indexPath as NSIndexPath).row]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ShowMemeViewController") as! ShowMemeViewController
        controller.image = meme.memedImage
        present(controller, animated: true)
    }
}
