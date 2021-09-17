
import Foundation

protocol FeedDataDelegate: AnyObject {
    
    func commentsDidTouch(post: Post)
    
}

protocol ProfileDelegate: AnyObject {
    
    func userNameDidTouch()
    
}

protocol ActivityDelegate1: AnyObject {
    
    func scrollTo(index: Int)
    
    func activityDidTouch()
    
}
