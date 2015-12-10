public extension UINavigationController
{
    public var rootViewController: UIViewController
    {
        return self.viewControllers.first!
    }


    public func setTransparentNavigationBar()
    {
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.translucent = true
    }
}
