//
//  NowPlayingTableViewCell.swift
//  TMDBApp
//
//  Created by Mert Ziya on 13.01.2025.
//

import UIKit

protocol PageDelegate : AnyObject{
    func didChangePage(selectedPage: Int?, selectedTitle : Title?, row : Int? , selectedHeading : String?)
}

class WideMovieCellContainer: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    
    // MARK: - Properties:
    lazy var moviesToShow : [Movie] = []{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
                // Calculate the desired pixel offset
                let customOffset = CGPoint(x: 0, y: 0) // Adjust 'x' for horizontal offset in pixels
                self.collectionView.setContentOffset(customOffset, animated: true)
            }
        }
    }
    lazy var seriesToShow : [Series] = []{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
                // Calculate the desired pixel offset
                let customOffset = CGPoint(x: 0, y: 0) // Adjust 'x' for horizontal offset in pixels
                self.collectionView.setContentOffset(customOffset, animated: true)
            }
        }
    }
    var isShowingMovies = true
    
    var selectedTitle : Title?
    var selectedPage : Int? = 0{
        didSet{
            pageNumber.text = String(describing: selectedPage ?? 1)
        }
    }
    var selectedRow : Int?
    var selectedHeadingText : String?
    
    weak var delegate: PageDelegate?
    
    // MARK: - UI Elements:
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sectionHeading: UILabel!
    
    @IBOutlet weak var previousPage: UIButton!
    @IBOutlet weak var nextPage: UIButton!
    @IBOutlet weak var pageNumber: UILabel!
    
    
    // MARK: - Lifecycles:
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "WideMovieCell", bundle: nil), forCellWithReuseIdentifier: "WideMovieCell")
            
        // When user taps the table view cell it becomes a different color which is identicating that user selected the cell
        // This functionality isn't wanted to there is a background view added to the subview to fix that problem.
        setupBackgroundCover()
        
        nextPageAction()
        previousPageAction()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



// MARK: - Collection View, inside the table view Cell
extension WideMovieCellContainer{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isShowingMovies ? moviesToShow.count : seriesToShow.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WideMovieCell", for: indexPath) as? WideMovieCell else{
            print("DEBUG: Now playing Dequeue Error")
            return UICollectionViewCell()
        }

        let title : String?
        let averageVote : Double?
        let backdropPath : String?
        if isShowingMovies{
            cell.selectedMovie = moviesToShow[indexPath.row]
            cell.isMovieSelected = true
            
            title = moviesToShow[indexPath.row].title
            averageVote = moviesToShow[indexPath.row].vote_average
            backdropPath = moviesToShow[indexPath.row].backdrop_path
        } else {
            cell.selectedSeries = seriesToShow[indexPath.row]
            cell.isMovieSelected = false
            
            title = seriesToShow[indexPath.row].name
            averageVote = seriesToShow[indexPath.row].vote_average
            backdropPath = seriesToShow[indexPath.row].backdrop_path
        }
        
        
        
        
        // All the cell data is shown after the image is uploaded
        if let unwrapped_poster_path = backdropPath{
            cell.movieImage.image = UIImage.solidGray
            cell.indicator.startAnimating()
            ImageService.fetchImage(posterPath: unwrapped_poster_path) { poster in
                DispatchQueue.main.async {
                    cell.indicator.stopAnimating()
                    cell.movieImage.image = poster
                    cell.movieName.text = title
                    
                    // Since there is 5 stars, and all vote_avatage is evaluated up to 10 points the score is divided by 2.
                    cell.movieRating.text = String(format: "%.1f", (averageVote ?? 0) / 2)
                    cell.ratingStars.rating = ((averageVote ?? 0) / 2)

                }
            }
        }else{
            cell.indicator.stopAnimating()
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
}


// MARK: - Table View Cell UI Configurations
extension WideMovieCellContainer{
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
        
        previousPage.layer.cornerRadius = previousPage.bounds.width / 2
        nextPage.layer.cornerRadius = nextPage.bounds.width / 2
    }
}


// MARK: - Actions:
extension WideMovieCellContainer {
    
    private func previousPageAction(){
        previousPage.addTarget(self, action: #selector(previousPageTapped), for: .touchUpInside)
    }
    private func nextPageAction(){
        nextPage.addTarget(self, action: #selector(nextPageTapped), for: .touchUpInside)
    }
    
    @objc private func previousPageTapped(){
        var updatedPage = selectedPage ?? 1
        if updatedPage > 1{ updatedPage -= 1}
        
        delegate?.didChangePage(selectedPage: updatedPage, selectedTitle: selectedTitle, row: selectedRow , selectedHeading: selectedHeadingText)
    }
    
    @objc private func nextPageTapped(){
        let updatedPage = (selectedPage ?? 1) + 1
        
        delegate?.didChangePage(selectedPage: updatedPage, selectedTitle: selectedTitle, row: selectedRow , selectedHeading: selectedHeadingText)
    }
    
}
