public extension UIWindow {

    public func visibleViewController() -> UIViewController? {

        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        }

        return nil
    }

    public class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {

        if let navigationController = vc as? UINavigationController {

            return UIWindow.getVisibleViewControllerFrom(navigationController.visibleViewController!)

        } else if let tabBarController = vc as? UITabBarController {

            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)

        } else if let pageViewController = vc as? UIPageViewController, currentVC = pageViewController.viewControllers?.first {

            return UIWindow.getVisibleViewControllerFrom(currentVC)

        } else {

            if let presentedViewController = vc.presentedViewController {

                return UIWindow.getVisibleViewControllerFrom(presentedViewController)

            } else {

                return vc
            }
        }
    }
}
