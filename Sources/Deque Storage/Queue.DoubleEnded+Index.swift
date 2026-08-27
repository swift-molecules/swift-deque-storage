public import Deque
public import Index
public import Store_Protocol

extension __QueueDoubleEnded where S: Store.`Protocol` & ~Copyable {

    public typealias Index = Index.Index<S.Element>
}
