import Foundation

protocol APODRoute {
    var apodTransition: Transition { get }
    func openAPODModule()
}

extension APODRoute where Self: RouterProtocol {
    func openAPODModule() {
        let module = APODModule()
        let transition = apodTransition
        module.router.openTransition = transition
        self.open(module.viewController, transition: transition)
    }
}
