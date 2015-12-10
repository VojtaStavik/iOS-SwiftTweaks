public extension UIScreen {
    public class func screenWidth() -> CGFloat! {
        return UIScreen.mainScreen().bounds.size.width
    }

    public class func screenHeight() -> CGFloat! {
        return UIScreen.mainScreen().bounds.size.height
    }
}
