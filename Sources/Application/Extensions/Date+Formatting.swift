import Foundation

extension Date {
  func formatAsYear() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    return formatter.string(from: self)
  }

  func formatAsMonthDayYear() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: self)
  }
}

extension DateFormatter {
  static let articleDate: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd, yyyy"
    return formatter
  }()
}
