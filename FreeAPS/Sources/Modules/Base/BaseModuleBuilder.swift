import SwiftUI
import Swinject

protocol ModuleBuilder {
    associatedtype View: SwiftUI.View
    func buildView() -> AnyView
}

class BaseModuleBuilder<View: BaseView, ViewModel: ObservableObject, Provider: FreeAPS.Provider>: ModuleBuilder
    where ViewModel: BaseViewModel<Provider>, View.ViewModel == ViewModel
{
    let resolver: Resolver
    lazy var viewModel: ViewModel = { buildViewModel() }()

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    func buildViewModel() -> ViewModel {
        ViewModel(provider: Provider(resolver: resolver), resolver: resolver)
    }

    func buildView() -> AnyView {
        View().environmentObject(viewModel).asAny()
    }
}
