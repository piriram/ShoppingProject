//
//  Extension.swift
//  ShoppingProject
//
//  Created by piri kim on 7/29/25.
//

import Foundation

extension Int {
    var decimalString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

extension String {
    var decimalString: String {
        guard let number = Int(self) else { return self }
        return number.decimalString
    }
    var removedHtml: String {
            // 정규식: <로 시작해서 >로 끝나는 문자열 제거
            let pattern = "<[^>]+>"
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                let range = NSRange(startIndex..., in: self)
                let result = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
                return result
            } catch {
                print("⚠️ 정규식 파싱 실패: \(error.localizedDescription)")
                return self
            }
        }
    var exportedHtml: String {
        guard let data = self.data(using: .utf16) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html
        ]
        
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil) // 오브젝트c 기반이라 do-catch문으로 크래시 방지가 안됨
            return attributedString.string
        } catch {
            print("HTML 변환 실패: \(error.localizedDescription)")
            return self // fallback
        }
    }

}
