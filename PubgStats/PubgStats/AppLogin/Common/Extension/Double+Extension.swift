//
//  Double+Extension.swift
//  PubgStats
//
//  Created by Ruben Rodriguez on 4/3/24.
//

extension Double {
    func formattedDouble(_ decimal: String = "%.0f") -> String {
        return self >= 1_000_000 ? String(format: "%.1f M", self / 1_000_000) : String(format: decimal, self)
    }
}

extension String {
    func formattedString() -> String {
        guard let amount = Double(self) else { return self}
        return amount >= 1_000_000 ? String(format: "%.1f M", amount / 1_000_000) : self
    }
}
