//
//  ProfilePage.swift
//  StarterApp
//
//  Created by Sam Thaiyil on 2021-05-05.
//

import UIKit

class ProfilePage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width: self.view.frame.width / 3, height: self.view.frame.width / 3)
   }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as? ProfilePageCell
        
        cell!.title.text = nil
        cell!.title.text = "Highlight 1"
        
        return cell!
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    layout.itemSize = CGSize(width: view.frame.width/3, height:view.frame.width/3)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0
                    collectionView!.collectionViewLayout = layout

        // Do any additional setup after loading the view.
    }
    
    @IBAction func upload(_ sender: Any) {
        performSegue(withIdentifier: "toUpload", sender: nil)
    }
   
    
    @IBAction func editDetails(_ sender: Any) {
        performSegue(withIdentifier: "toEditDetails", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
