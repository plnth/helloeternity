import Foundation

final class GroupedApodsRouter: Router<GroupedApodsViewController> {
    
}

extension GroupedApodsRouter: SingleApodRoute {
    
    var singleApodTransition: Transition {
        return PushTransition()
    }
}
