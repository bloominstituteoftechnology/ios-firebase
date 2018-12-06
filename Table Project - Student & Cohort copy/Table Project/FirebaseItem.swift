
import Foundation

// This is a protocol
// Anything that supplies a record identifier and conforms to the protocol, we can use
protocol FirebaseItem: class {
    var recordIdentifier: String { get set }
}
