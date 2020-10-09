import UIKit

final class MainRouter: Router<MainViewController>, MainRouter.Routes {
    typealias Routes = APODRoute
    
    var apodTransition: Transition {
        return PushTransition()
    }
}
