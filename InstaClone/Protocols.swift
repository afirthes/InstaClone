
import Foundation

protocol FeedDataDelegate: AnyObject {
    func commentsDidTouch(post: PostModel, likesModel: LikesModel, userModel: UserModel)
}

protocol ProfileDelegate: AnyObject {
    func userNameDidTouch()
}

protocol ActivityDelegate1: AnyObject {
    func scrollTo(index: Int)
    func activityDidTouch()
}

protocol ProfileHeaderDelegate: AnyObject {
    func profileImageDidTouch()
}

