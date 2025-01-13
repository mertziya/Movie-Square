//
//  NowPlayingTableViewCell.swift
//  TMDBApp
//
//  Created by Mert Ziya on 13.01.2025.
//

import UIKit

class WideMovieCellContainer: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    lazy var moviesToShow : [Movie] = []{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sectionHeading: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "WideMovieCell", bundle: nil), forCellWithReuseIdentifier: "WideMovieCell")
        
        sectionHeading.text = "Now Playing"
    
                
        // When user taps the table view cell it becomes a different color which is identicating that user selected the cell
        // This functionality isn't wanted to there is a background view added to the subview to fix that problem.
        setupBackgroundCover()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesToShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WideMovieCell", for: indexPath) as? WideMovieCell else{
            print("DEBUG: Now playing Dequeue Error")
            return UICollectionViewCell()
        }
        
        cell.movieName.text = moviesToShow[indexPath.row].title
        
        
        
        // Since there is 5 stars, and all vote_avatage is evaluated up to 10 points the score is divided by 2.
        cell.movieRating.text = String(format: "%.1f", (moviesToShow[indexPath.row].vote_average ?? 0) / 2)
        cell.ratingStars.rating = ((moviesToShow[indexPath.row].vote_average ?? 0) / 2)
        
        if let unwrapped_poster_path = moviesToShow[indexPath.row].poster_path {
            print(unwrapped_poster_path)
            
            ImageService.fetchImage(posterPath: unwrapped_poster_path) { poster in
                    cell.indicator.stopAnimating()
                    cell.movieImage.image = poster
                    cell.indicator.stopAnimating()
                
            }
        }else{
            cell.movieImage.image = UIImage.solidGray
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 266)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
 
    
  
    
    private func setupBackgroundCover(){
        let bgView = UIView()
        insertSubview(bgView, at: 0)
        bgView.backgroundColor = .systemBackground
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            bgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            bgView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
    
}
