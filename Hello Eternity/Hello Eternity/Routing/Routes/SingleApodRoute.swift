import Foundation

enum SingleApodModuleConfiguration {
    case network
    case storage(String)
}

protocol SingleApodRoute {
    var singleApodTransition: Transition { get }
    func openSingleApodModule(configuration: SingleApodModuleConfiguration)
}

extension SingleApodRoute where Self: RouterProtocol {
    func openSingleApodModule(configuration: SingleApodModuleConfiguration) {
        let module = SingleApodModule(configuration: configuration)
        let transition = singleApodTransition
        module.router.openTransition = transition
        self.open(module.viewController, transition: transition)
    }
}
