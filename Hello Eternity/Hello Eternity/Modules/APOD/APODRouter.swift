import Foundation

final class APODRouter: Router<APODViewController>, SingleAPODRoute {
    typealias Routes = Closable & SingleAPODRoute //TODO
    
    var singleAPODTransition: Transition {
        return PushTransition()
    }
}
