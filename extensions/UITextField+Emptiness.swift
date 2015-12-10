public extension UITextField
{
    public var isEmpty: Bool
    {
        return text?.isEmpty ?? true
    }

    public var isNotEmpty: Bool
    {
        return !isEmpty
    }
}
