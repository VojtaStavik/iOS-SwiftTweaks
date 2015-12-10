public extension UIImage
{

    /**
    Returns image with size 1x1px of certain color.
    */
    public class func imageWithColor(color : UIColor) -> UIImage
    {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    /**
    Returns current image colored to certain color.
    */
    @available(*, deprecated, message="Use similar build-in XCAssetCatalog functionality.")
    public func imageWithColor(color: UIColor) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)


        CGContextSetBlendMode(context, .Normal)

        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        CGContextClipToMask(context, rect, self.CGImage)
        color.setFill()
        CGContextFillRect(context, rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage;
    }
}
