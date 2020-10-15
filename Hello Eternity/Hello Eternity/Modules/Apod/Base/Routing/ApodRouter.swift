import Foundation

protocol SingleApodRouterCreator {
    func createSingleApodRouter() -> SingleApodRouter
}

extension SingleApodRouterCreator {
    func createSingleApodRouter() -> SingleApodRouter {
        return SingleApodRouter(configuration: .network)
    }
}

protocol GroupedApodsRouterCreator {
    func createGroupedApodsRouter() -> GroupedApodsRouter
}

extension GroupedApodsRouterCreator {
    func createGroupedApodsRouter() -> GroupedApodsRouter {
        return GroupedApodsRouter()
    }
}

final class ApodRouter: Router<ApodViewController> {
    typealias Routes = Closable
}

extension ApodRouter: SingleApodRouterCreator {}
extension ApodRouter: GroupedApodsRouterCreator {}
