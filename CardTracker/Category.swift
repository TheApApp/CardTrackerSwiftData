// MARK: - Enum for Category
/// Enum to represent the category of the recipient
enum Category: String, Codable {
    case home
    case work
    
    var id: String { self.rawValue } // Conformance to Identifiable

    static var allCategories: [Category] {
        return Category.allCases
    }
}
