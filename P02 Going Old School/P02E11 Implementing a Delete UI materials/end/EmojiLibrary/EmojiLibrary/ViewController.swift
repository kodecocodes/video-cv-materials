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

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  let dataSource = DataSource()
  let delegate = EmojiCollectionViewDelegate(numberOfItemsPerRow: 6, interItemSpacing: 8)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = dataSource
    collectionView.delegate = delegate
    
    navigationItem.leftBarButtonItem = editButtonItem
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    
    collectionView.indexPathsForVisibleItems.forEach {
      guard let emojiCell = collectionView.cellForItem(at: $0) as? EmojiCell else { return }
      emojiCell.isEditing = editing
    }
    
    if !isEditing {
      collectionView.indexPathsForSelectedItems?.compactMap({ $0 }).forEach {
        collectionView.deselectItem(at: $0, animated: true)
      }
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if isEditing && identifier == "showEmojiDetail" {
      return false
    }
    
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard
      segue.identifier == "showEmojiDetail",
      let emojiCell = sender as? EmojiCell,
      let emojiDetailController = segue.destination as? EmojiDetailController,
      let indexPath = collectionView.indexPath(for: emojiCell),
      let emoji = Emoji.shared.emoji(at: indexPath)
    else {
      return
    }
    
    emojiDetailController.emoji = emoji
  }
  
  @IBAction func addEmoji(_ sender: Any) {
    let (category, randomEmoji) = Emoji.randomEmoji()
    dataSource.addEmoji(randomEmoji, to: category)
    let emojiCount = collectionView.numberOfItems(inSection: 0)
    let insertedIndex = IndexPath(item: emojiCount, section: 0)
    collectionView.insertItems(at: [insertedIndex])
  }
}

