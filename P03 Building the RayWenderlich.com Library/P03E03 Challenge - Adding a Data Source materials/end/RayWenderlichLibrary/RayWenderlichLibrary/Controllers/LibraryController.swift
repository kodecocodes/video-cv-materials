/// These materials have been reviewed and are updated as of September, 2020
///
/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///


import UIKit

final class LibraryController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<TutorialCollection, Tutorial>!
  private let tutorialCollections = DataSource.shared.tutorials
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  private func setupView() {
    self.title = "Library"
    
    collectionView.collectionViewLayout = configureCollectionViewLayout()
    configureDataSource()
    configureSnapshot()
  }
}

// MARK: - Collection View -

extension LibraryController {
  func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
      
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(0.3))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .groupPaging
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      section.interGroupSpacing = 10
      
      return section
    }
    
    return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
  }
}

// MARK: - Diffable Data Source -

extension LibraryController {
  typealias TutorialDataSource = UICollectionViewDiffableDataSource<TutorialCollection, Tutorial>
  
  func configureDataSource() {
    dataSource = TutorialDataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, tutorial: Tutorial) -> UICollectionViewCell? in
     
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorialCell.reuseIdentifier, for: indexPath) as? TutorialCell else {
        return nil
      }
      
      cell.titleLabel.text = tutorial.title
      cell.thumbnailImageView.image = tutorial.image
      cell.thumbnailImageView.backgroundColor = tutorial.imageBackgroundColor
      
      return cell
    }
  }
  
  func configureSnapshot() {
    var currentSnapshot = NSDiffableDataSourceSnapshot<TutorialCollection, Tutorial>()
    
    tutorialCollections.forEach { collection in
      currentSnapshot.appendSections([collection])
      currentSnapshot.appendItems(collection.tutorials)
    }
    
    dataSource.apply(currentSnapshot, animatingDifferences: false)
  }
}
