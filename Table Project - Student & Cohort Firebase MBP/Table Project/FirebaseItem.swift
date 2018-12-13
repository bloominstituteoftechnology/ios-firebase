
// Protocol that makes the firebase networking code reusable
// Anything that conforms to FirebaseItem has to have a record identifier that is a string

import Foundation

protocol FirebaseItem: class {
    var recordIdentifier: String { get set }
}
