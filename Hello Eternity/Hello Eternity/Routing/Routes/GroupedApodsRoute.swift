import Foundation

protocol GroupedApodsRoute {
    var groupedApodsTransition: Transition { get }
    func openGropedApodsModule()
}

extension GroupedApodsRoute where Self: RouterProtocol {
    func openGropedApodsModule() {
        let module = GroupedApodsModule()
        let transition = self.groupedApodsTransition
        module.router.openTransition = transition
        self.open(module.viewController, transition: transition)
    }
}
