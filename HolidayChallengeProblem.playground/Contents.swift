import UIKit

var inputString = "The quick <fox> jumped through the <door>"
var keys = ["dog",
            "hoop"]

struct RegexMatch {
    var text: String
    var range: (Int, Int)
    init(text: String, result: NSTextCheckingResult) {
        self.text = String(text[Range(result.range, in: text)!])
        self.range = (Range(result.range)!.lowerBound, Range(result.range)!.upperBound)
    }
}

func getRegexMatches(for regex: String, in text: String) -> [RegexMatch] {
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            RegexMatch(text: text, result: $0)
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

func applyKeys(keys: [String], inputString: String) -> String {
    var newString = inputString as NSString
    var adjustment = 0
    for (i, regexMatch) in getRegexMatches(for: "<[^<]+>", in: inputString).enumerated() {
        let range = NSRange(regexMatch.range.0+adjustment..<regexMatch.range.1+adjustment)
        if i < keys.count {
            newString = newString.replacingCharacters(in: range, with: keys[i]) as NSString
            adjustment -= range.length - keys[i].count
        }
    }
    return newString.standardizingPath
}

print(inputString)
applyKeys(keys: keys, inputString: inputString)
