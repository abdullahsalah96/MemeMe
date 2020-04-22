
import UIKit

class CollectionViewController: UICollectionViewController{
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    func configureLayout(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createMeme))
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    @objc func createMeme(){
//        performSegue(withIdentifier: "collectionMemeSegue", sender: self)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeCreationViewController") as! MemeCreationViewController
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as! MemeCollectionCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImage.image = meme.memedImage
        cell.label.text = meme.topText
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = self.memes[(indexPath as NSIndexPath).row]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ShowMemeViewController") as! ShowMemeViewController
        controller.image = meme.memedImage
        present(controller, animated: true)
    }
}
