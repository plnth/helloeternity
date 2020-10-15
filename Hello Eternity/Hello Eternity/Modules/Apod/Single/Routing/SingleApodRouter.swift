import Foundation

final class SingleApodRouter: Router<SingleApodViewController> {
    
    let configuration: ApodConfiguration
    
    init(configuration: ApodConfiguration) {
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
