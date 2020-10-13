import Foundation

final class SingleAPODRouter: Router<SingleAPODViewController>, SingleAPODRouter.Routes {
    typealias Routes = SingleAPODRoute
    
    let configuration: SingleAPODModuleConfiguration
    
    init(configuration: SingleAPODModuleConfiguration) {
        self.configuration = configuration
    }
    
    var singleAPODTransition: Transition {
        return PushTransition()
    }
}
