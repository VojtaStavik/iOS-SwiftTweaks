public extension UIImage {

    func saveJpegToTemp(quality: CGFloat = 0.8) -> String? {

        let fileManager = NSFileManager.defaultManager()
        let dir = NSTemporaryDirectory()
        let fileName = NSProcessInfo.processInfo().globallyUniqueString
        let filePathToWrite = "\(dir)/\(fileName).jpg"

        let imageData = UIImageJPEGRepresentation(self, quality)
        imageData?.writeToFile(filePathToWrite, atomically: false)

        return fileManager.fileExistsAtPath(filePathToWrite) ? filePathToWrite : nil
    }
}
