import Foundation

final class GroupedApodsRouter: Router<GroupedApodsViewController> {
    
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
