import Foundation

final class GroupedApodsRouter: Router<GroupedApodsViewController> {
    let configuration: ApodConfiguration
    
    init(configuration: ApodConfiguration) {
        self.configuration = configuration
    }
}

extension GroupedApodsRouter: GroupedApodsRoute {
    
    var groupedApodsTransition: Transition {
        return PushTransition()
    }
}

extension GroupedApodsRouter: SingleApodRoute {
    
    var singleApodTransition: Transition {
        return PushTransition()
    }
}
