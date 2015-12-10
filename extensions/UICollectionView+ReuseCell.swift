public extension UICollectionReusableView {

    static public var autoReuseIdentifier : String {
        return NSStringFromClass(self) + "AutogenerateIdentifier"
    }
}

public extension UICollectionView {

    public var currentPageNumber: Int {
        return Int(ceil(self.contentOffset.x / self.frame.size.width))
    }

    public func dequeue<T: UICollectionReusableView>(cell cell: T.Type, indexPath: NSIndexPath) -> T? {
        return dequeueReusableCellWithReuseIdentifier(T.autoReuseIdentifier, forIndexPath: indexPath) as? T
    }

    public func dequeue<T: UICollectionReusableView>(header header: T.Type, indexPath: NSIndexPath) -> T? {
        return  dequeueReusableSupplementaryViewOfKind(
            UICollectionElementKindSectionHeader,
            withReuseIdentifier: T.autoReuseIdentifier,
            forIndexPath: indexPath)    as? T
    }

    public func dequeue<T: UICollectionReusableView>(footer footer: T.Type, indexPath: NSIndexPath) -> T? {
        return  dequeueReusableSupplementaryViewOfKind(
            UICollectionElementKindSectionFooter,
            withReuseIdentifier: T.autoReuseIdentifier,
            forIndexPath: indexPath)    as? T
    }

    public func registerCell<T: UICollectionReusableView>(cell : T.Type) {
        registerNib(nibFromClass(cell), forCellWithReuseIdentifier: cell.autoReuseIdentifier)
    }

    public func registerSectionHeader<T: UICollectionReusableView>(header : T.Type) {
        registerNib(nibFromClass(header), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: header.autoReuseIdentifier)
    }

    public func registerSectionFooter<T: UICollectionReusableView>(footer : T.Type) {
        registerNib(nibFromClass(footer), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
            withReuseIdentifier: footer.autoReuseIdentifier)
    }

    // Private

    private func nibFromClass(type: UICollectionReusableView.Type) -> UINib? {
        guard let nibName = NSStringFromClass(type).componentsSeparatedByString(".").last else {
            return nil
        }

        return UINib(nibName: nibName, bundle: nil)
    }
}
