import Foundation

final class SingleApodRouter: Router<SingleApodViewController> {
    
    let configuration: SingleApodModuleConfiguration
    
    init(configuration: SingleApodModuleConfiguration) {
        self.configuration = configuration
    }
}

extension SingleApodRouter: SingleApodRoute {
    var singleApodTransition: Transition {
        return PushTransition()
    }
}

extension SingleApodRouter: GroupedApodsRoute {
    
    var groupedApodsTransition: Transition {
        return ModalTransition()
    }
}
