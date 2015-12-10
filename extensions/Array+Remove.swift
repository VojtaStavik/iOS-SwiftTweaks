public extension Array
{

    public var isEmpty : Bool
    {
        return count == 0
    }

    public var isNotEmpty : Bool
    {
        return !isEmpty
    }

    public mutating func removeObject<U: Equatable>(object: U)
    {
        var index: Int?

        for (idx, objectToCompare) in self.enumerate()
            {
                if let to = objectToCompare as? U
                {
                    if object == to
                    {
                        index = idx
                    }
                }
            }

        if let index = index
        {
            self.removeAtIndex(index)
        }
    }
}
