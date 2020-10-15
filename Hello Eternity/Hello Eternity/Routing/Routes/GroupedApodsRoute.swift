import Foundation

protocol GroupedApodsRoute {
    var groupedApodsTransition: Transition { get }
    func openGropedApodsModule(configuration: ApodConfiguration)
}

extension GroupedApodsRoute where Self: RouterProtocol {
    func openGropedApodsModule(configuration: ApodConfiguration) {
        let module = GroupedApodsModule(configuration: configuration)
        let transition = self.groupedApodsTransition
        module.router.openTransition = transition
        self.open(module.viewController, transition: transition)
    }
}
