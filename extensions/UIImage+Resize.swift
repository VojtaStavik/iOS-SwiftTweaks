extension UIImage {

    // Resizes the image according to the given content mode, taking into account the image's orientation
    func resizedImage(
        contentMode: UIViewContentMode = .ScaleAspectFit,
        bounds: CGSize = CGSizeMake(1000, 1000),
        interpolationQuality quality: CGInterpolationQuality = .High) -> UIImage {

        let horizontalRatio = bounds.width / self.size.width
        let verticalRatio = bounds.height / self.size.height
        let ratio: CGFloat

        switch (contentMode) {
        case .ScaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .ScaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        default:
            ratio = min(horizontalRatio, verticalRatio)
        }

        let newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio)

        let newImage = self.resizedImage(newSize, interpolationQuality:quality)

        return newImage
    }

    func resizedImage(newSize:CGSize, interpolationQuality quality:CGInterpolationQuality) -> UIImage {

        let drawTransposed: Bool

        switch (self.imageOrientation) {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            drawTransposed = true
        default:
            drawTransposed = false
        }

        return self.resizedImage(newSize,
            transform: self.transformForOrientation(newSize),
            drawTransposed:drawTransposed,
            interpolationQuality:quality)
    }

    // Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
    // The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
    // If the new size is not integral, it will be rounded up
    func resizedImage(newSize: CGSize,
        transform: CGAffineTransform,
        drawTransposed transpose: Bool,
        interpolationQuality quality: CGInterpolationQuality) -> UIImage {

        let newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
        let transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
        let imageRef = self.CGImage;

        // Build a context that's the same dimensions as the new size
        let bitmap = CGBitmapContextCreate(nil,
            Int(newRect.size.width),
            Int(newRect.size.height),
            CGImageGetBitsPerComponent(imageRef),
            0,
            CGImageGetColorSpace(imageRef),
            CGImageGetBitmapInfo(imageRef).rawValue)

        // Rotate and/or flip the image if required by its orientation
        CGContextConcatCTM(bitmap, transform);

        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(bitmap, quality);

        // Draw into the context; this scales the image
        CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);

        // Get the resized image from the context and a UIImage
        let newImageRef = CGBitmapContextCreateImage(bitmap);
        let newImage = UIImage(CGImage: newImageRef!)

        return newImage
    }

    func transformForOrientation(newSize:CGSize) -> CGAffineTransform {

        var transform = CGAffineTransformIdentity

        switch (self.imageOrientation) {
        case .Down, .DownMirrored:           // EXIF = 3, 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))

        case .Left, .LeftMirrored:           // EXIF = 6, 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))

        case .Right, .RightMirrored:          // EXIF = 8, 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        default:
            break
        }

        switch (self.imageOrientation) {
        case .UpMirrored, .DownMirrored:     // EXIF = 2, 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)

        case .LeftMirrored, .RightMirrored:   // EXIF = 5, 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        default:
            break
        }

        return transform
    }
}
