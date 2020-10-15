import Foundation

enum ApodConfiguration {
    case network
    case storage(String)
}

protocol ApodRoute {
    var apodTransition: Transition { get }
    func openApodModule()
}

extension ApodRoute where Self: RouterProtocol {
    func openApodModule() {
        let module = ApodModule()
        let transition = apodTransition
        module.router.openTransition = transition
        self.open(module.viewController, transition: transition)
    }
}
