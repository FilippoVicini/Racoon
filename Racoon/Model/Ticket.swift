import Foundation
import RealmSwift

class Fountain: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var reportedBy = ""
    @Persisted var product = ""
    @Persisted var type = "" // Added 'type' property
    @Persisted var title = ""
    @Persisted var problemDescription: String?
    @Persisted var created = Date()
    @Persisted var status = TicketStatus.notStarted
    @Persisted var address: String?

    convenience init(reportedBy: String, product: String, type: String, title: String, problemDescription: String?, address: String) {
        self.init()
        self.reportedBy = reportedBy
        self.product = product
        self.type = type
        self.title = title
        self.problemDescription = problemDescription
        self.address = address
    }
}

enum TicketStatus: String, PersistableEnum {
    case notStarted
    case inProgress
    case complete
}
