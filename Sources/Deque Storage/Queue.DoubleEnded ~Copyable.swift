import Affine_Standard_Library_Integration
public import Buffer_Protocol
import Index
import Ordinal_Standard_Library_Integration
public import Deque
public import Store_Protocol

extension __QueueDoubleEnded where S: ~Copyable, S: Store::Store.`Protocol` & Buffer.`Protocol` {

    @inlinable
    public var count: Index.Count { store.count }

    @inlinable
    public var isEmpty: Bool { store.isEmpty }

    @inlinable
    public var capacity: Index.Count { store.capacity }

    @inlinable
    public var freeCapacity: Index.Count {
        store.capacity.subtract.saturating(store.count)
    }
}

extension __QueueDoubleEnded where S: ~Copyable, S: Store::Store.`Protocol` & Buffer.`Protocol` {

    @inlinable
    public mutating func pop(from position: Position) -> S.Element? {
        guard !isEmpty else { return nil }
        store.unshare()
        switch position {
        case .front:
            return store.move(at: .zero)

        case .back:
            let last: Index = store.count.subtract.saturating(.one).map(Ordinal.init)
            return store.move(at: last)
        }
    }

    @inlinable
    public mutating func take(from position: Position) -> S.Element? {
        pop(from: position)
    }

    @inlinable
    public func peek<R>(at position: Position, _ body: (borrowing S.Element) -> R) -> R? {
        guard !isEmpty else { return nil }
        switch position {
        case .front:
            return body(store[.zero])

        case .back:
            let last: Index = store.count.subtract.saturating(.one).map(Ordinal.init)
            return body(store[last])
        }
    }

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        store.unshare()
        while !isEmpty {
            body(store.move(at: .zero))
        }
    }

    @inlinable
    public func forEach(_ body: (borrowing S.Element) -> Void) {
        var slot: Index = .zero
        let end = count.map(Ordinal.init)
        while slot < end {
            body(store[slot])
            slot = slot.successor.saturating()
        }
    }
}

extension __QueueDoubleEnded
where
    S: ~Copyable,
    S.Element: Copyable,
    S: Store::Store.`Protocol` & Buffer.`Protocol`
{

    @inlinable
    public func peek(at position: Position) -> S.Element? {
        peek(at: position) { copy $0 }
    }
}

extension __QueueDoubleEnded where S: Copyable, S: Store::Store.`Protocol` {

    @inlinable
    public borrowing func clone() -> Self {
        var result = copy self
        result.store.unshare()
        return result
    }
}
