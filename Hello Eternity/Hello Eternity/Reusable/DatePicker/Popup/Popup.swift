import UIKit

protocol PopupDelegate: class {
    var popupView: UIView { get }
    var blurEffectStyle: UIBlurEffect.Style { get }
    var initialScaleAmount: CGFloat { get }
    var animationDuration: TimeInterval { get }
}

class Popup: NSObject {
    private static var shared = Popup()
    
    private var visualEffectBlurView: UIVisualEffectView?
    private var isPresenting: Bool = false
    
    private static var useBlur: Bool = false
    
    public static func show(_ viewControllerToPresent: UIViewController, on parent: UIViewController, useBlur: Bool = false) {
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        viewControllerToPresent.transitioningDelegate = shared
        Popup.useBlur = useBlur
        
        guard viewControllerToPresent is PopupDelegate else { return }
        
        parent.present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    private func animatePresent(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedViewController = transitionContext.viewController(forKey: .to),
              let presentedControllerDelegate = presentedViewController as? PopupDelegate else { return }
        
        presentedViewController.view.alpha = 0
        presentedViewController.view.frame = transitionContext.containerView.bounds
        
        transitionContext.containerView.addSubview(presentedViewController.view)
        
        self.createBlurIfNeeded(in: transitionContext)
        
        presentedControllerDelegate.popupView.alpha = 0
        let scaleAmount = presentedControllerDelegate.initialScaleAmount
        presentedControllerDelegate.popupView.transform = CGAffineTransform(scaleX: scaleAmount, y: scaleAmount)

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: 0.75 * duration) {
            self.visualEffectBlurView?.effect = UIBlurEffect(style: presentedControllerDelegate.blurEffectStyle)
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.0,
                       options: .allowUserInteraction,
                       
                       animations: {
                        presentedViewController.view.alpha = 1
                        presentedControllerDelegate.popupView.alpha = 1
                        presentedControllerDelegate.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        
                       }) { transitionContext.completeTransition($0) }
    }
    
    private func animateDismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedViewController = transitionContext.viewController(forKey: .from),
              let presentedControllerDelegate = presentedViewController as? PopupDelegate else { return }
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 2.0,
                       initialSpringVelocity: 0.0,
                       options: .allowUserInteraction,
                       
                       animations: {
                        presentedViewController.view.alpha = 0
                        self.visualEffectBlurView?.alpha = 0
                        let scaleAmount = presentedControllerDelegate.initialScaleAmount
                        presentedControllerDelegate.popupView.transform = CGAffineTransform(scaleX: scaleAmount, y: scaleAmount)
                        
                       }) { [weak self] didComplete in
            self?.visualEffectBlurView?.effect = nil
            self?.visualEffectBlurView?.removeFromSuperview()
            transitionContext.completeTransition(didComplete)
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension Popup: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
}

//MARK: - UIViewControllerAnimatedTransitioning
extension Popup: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        if let toViewControllerDelegate = transitionContext?.viewController(forKey: .to) as? PopupDelegate {
            return toViewControllerDelegate.animationDuration
        }
        
        if let fromViewControllerDelegate = transitionContext?.viewController(forKey: .from) as? PopupDelegate {
            return fromViewControllerDelegate.animationDuration
        }
        
        return 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if self.isPresenting {
            self.animatePresent(transitionContext: transitionContext)
        } else {
            self.animateDismiss(transitionContext: transitionContext)
        }
    }
}

fileprivate extension Popup {
    
    func createBlurIfNeeded(in transitionContext: UIViewControllerContextTransitioning) {
        if Popup.useBlur {
            self.visualEffectBlurView = UIVisualEffectView()
            self.setupBlurEffect(in: transitionContext)
        }
    }
    
    func setupBlurEffect(in transitionContext: UIViewControllerContextTransitioning) {
        
        guard let visualEffectBlurView = self.visualEffectBlurView else { return }
        
        visualEffectBlurView.frame = transitionContext.containerView.bounds
        visualEffectBlurView.alpha = 1
        
        transitionContext.containerView.insertSubview(visualEffectBlurView, at: 0)
        
        visualEffectBlurView.snp.makeConstraints { make in
            make.edges.equalTo(transitionContext.containerView)
        }
    }
}
