import Foundation

final class SingleApodRouter: Router<SingleApodViewController> {
    
    let configuration: SingleApodModuleConfiguration
    
    init(configuration: SingleApodModuleConfiguration) {
        self.configuration = configuration
    }
    
    var singleApodTransition: Transition {
        return PushTransition()
    }
}

extension SingleApodRouter: GroupedApodsRoute {
    
    var groupedApodsTransition: Transition {
        return ModalTransition()
    }
    
    func openGropedApodsModule() {
        //TODO
    }
}
