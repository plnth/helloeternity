import UIKit

final class ModalTransition: NSObject {
    
    var animator: Animator?
    var isAnimated: Bool = false
    
    var modalTransitionStyle: UIModalTransitionStyle
    var modalPresentationStyle: UIModalPresentationStyle
    
    var completionHandler: (() -> Void)?
    
    weak var viewController: UIViewController?
    
    init(animator: Animator? = nil, isAnimated: Bool = true, modalTransitionStyle: UIModalTransitionStyle = .coverVertical, modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
        self.animator = animator
        self.isAnimated = isAnimated
        self.modalTransitionStyle = modalTransitionStyle
        self.modalPresentationStyle = modalPresentationStyle
    }
}

//MARK: - Transition
extension ModalTransition: Transition {
    func open(_ viewController: UIViewController) {
        viewController.transitioningDelegate = self
        viewController.modalTransitionStyle = self.modalTransitionStyle
        viewController.modalPresentationStyle = self.modalPresentationStyle
        
        self.viewController?.present(viewController, animated: self.isAnimated, completion: self.completionHandler)
    }
    
    func close(_ viewController: UIViewController) {
        viewController.dismiss(animated: self.isAnimated, completion: self.completionHandler)
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension ModalTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = self.animator else { return nil }
        animator.isPresenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let animator = self.animator else { return nil }
        animator.isPresenting = false
        return animator
    }
}
