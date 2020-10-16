import UIKit

final class MainRouter: Router<MainViewController>, MainRouter.Routes {
    typealias Routes = ApodRoute //TODO: other major modules 
    
    var apodTransition: Transition {
        return PushTransition()
    }
}
