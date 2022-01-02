import Foundation

/// A dependency collection that provides resolutions for object instances.
open class DependencyManager {
    
    /// Stored object instance factories.
    fileprivate var modules = [String: Module]()
    
    /// Construct dependency resolutions.
    public init(@ModuleBuilder _ modules: () -> [Module]) {
        modules().forEach { add(module: $0) }
    }
    
    /// Construct dependency resolution.
    public init(@ModuleBuilder _ module: () -> Module) {
        add(module: module())
    }
    
    /// Assigns the current container to the composition root.
    open func build() {
        Self.root = self
    }
    
    fileprivate init() {}
    
    deinit { modules.removeAll() }
    
}

private extension DependencyManager {
    
    /// Composition root container of dependencies.
    static var root = DependencyManager()
    
    /// Registers a specific type and its instantiating factory.
    func add(module: Module) {
        modules[module.name] = module
    }

    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, an exception will occur.
    func resolve<T>(for name: String? = nil) -> T {
        let name = name ?? String(describing: T.self)
        
        guard let component: T = modules[name]?.resolve() as? T else {
            fatalError("Dependency '\(T.self)' not resolved!")
        }
        
        return component
    }
    
}

// MARK: Public API
public extension DependencyManager {
    
    /// DSL for declaring modules within the container dependency initializer.
	@resultBuilder struct ModuleBuilder {
        public static func buildBlock(_ modules: Module...) -> [Module] { modules }
        public static func buildBlock(_ module: Module) -> Module { module }
    }
    
    static func add(module: Module) {
        root.modules[module.name] = module
    }
    
    /// Resolves through inference and returns an instance of the given type from the current default container.
    ///
    /// If the dependency is not found, an exception will occur.
    static func instance<T>(type: T.Type) -> T {
        let name = String(describing: T.self)
        
        guard let component: T = DependencyManager.root.modules[name]?.resolve() as? T else {
            fatalError("Dependency '\(T.self)' not resolved!")
        }
        
        return component
    }
    
}

/// A type that contributes to the object graph.
public struct Module {
    
    fileprivate let name: String
    fileprivate let resolve: () -> Any
    
    public init<T>(_ name: String? = nil, _ resolve: @escaping () -> T) {
        self.name = name ?? String(describing: T.self)
        self.resolve = resolve
    }
    
}

/// Resolves an instance from the dependency injection container.
@propertyWrapper
public class Inject<Value> {
    
    private let name: String?
    private var storage: Value?
    
    public var wrappedValue: Value {
        storage ?? {
            let value: Value = DependencyManager.root.resolve(for: name)
            storage = value // Reuse instance for later
            return value
        }()
    }
    
    public init() {
        self.name = nil
    }
    
    public init(_ name: String) {
        self.name = name
    }
    
}
