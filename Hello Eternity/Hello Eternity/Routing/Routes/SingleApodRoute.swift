import Foundation

protocol SingleApodRoute {
    var singleApodTransition: Transition { get }
    func openSingleApodModule(configuration: ApodConfiguration)
}

extension SingleApodRoute where Self: RouterProtocol {
    func openSingleApodModule(configuration: ApodConfiguration) {
        let module = SingleApodModule(configuration: configuration)
        let transition = singleApodTransition
        module.router.openTransition = transition
        self.open(module.viewController, transition: transition)
    }
}
