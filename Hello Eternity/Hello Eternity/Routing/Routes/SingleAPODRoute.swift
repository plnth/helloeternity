import Foundation

enum SingleAPODModuleConfiguration {
    case network
    case storage(String)
}

protocol SingleAPODRoute {
    var singleAPODTransition: Transition { get }
    func openSingleAPODModule(configuration: SingleAPODModuleConfiguration)
}

extension SingleAPODRoute where Self: RouterProtocol {
    func openSingleAPODModule(configuration: SingleAPODModuleConfiguration) {
        let module = SingleAPODModule(configuration: configuration)
        let transition = singleAPODTransition
        module.router.openTransition = transition
        self.open(module.viewController, transition: transition)
    }
}
