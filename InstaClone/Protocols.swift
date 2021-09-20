
import Foundation

protocol FeedDataDelegate: AnyObject {
    func commentsDidTouch(post: PostModel, likesModel: LikesModel, userModel: UserModel)
}

protocol ProfileDelegate: AnyObject {
    func userNameDidTouch(userId: String)
}

protocol ActivityDelegate1: AnyObject {
    func scrollTo(index: Int)
    func activityDidTouch()
}

protocol ProfileHeaderDelegate: AnyObject {
    func profileImageDidTouch()
}

protocol PostDeleDelegate: AnyObject {
    func confirmDelete(postId: String)
}
