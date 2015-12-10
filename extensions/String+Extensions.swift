public extension String
{
    public var urlEncodeString: String? {
        get {
            let allowedCharacters = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
            allowedCharacters.removeCharactersInString("+/=")

            return self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
        }
    }

    public subscript (i: Int) -> Character
    {
        return self[self.startIndex.advancedBy(i) ]
    }

    public subscript (i: Int) -> String
    {
        return String(self[i] as Character)
    }

    public subscript (r: Range<Int>) -> String
    {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }

    public func isValidEmail() -> Bool
    {

        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: [NSRegularExpressionOptions.CaseInsensitive])

        return regex?.firstMatchInString(self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }

    public func isLongerThen(input: Int) -> Bool
    {
        return self.characters.count > input
    }

    public var isNotEmpty: Bool
    {
        return !isEmpty
    }
}
