import UIKit

class QiitaItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    func configure(item: QiitaItem){
        
        self.titleLabel.text = item.title
        self.likeCountLabel.text = String(item.likes_count)
        self.commentCountLabel.text = String(item.comments_count)
        self.updatedDateLabel.text = item.created_at.convertDateFormat(from: DateFormat.ISO8601Format, to: DateFormat.japaneseFormat)
        
        guard let user = item.user else {
            return
        }
        self.profileNameLabel.text = user.github_login_name        
    }
}
