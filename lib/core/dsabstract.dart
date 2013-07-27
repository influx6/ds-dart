part of ds.core;

class dsImpl {
	
	void addAll();
	void add();
	void free();
	void append();
	void prepend();
	void appendOn(dsNode n,dsNode m);
	void prependOn(dsNode n,dsNode m);
	dynamic get root;
	bool get isEmpty;
	
}

class dsIteratorHelpers{
	void reset();
}
	
class dsIteratorImpl{
	void moveNext();
	dynamic get current;	
}

class DS implements dsImpl{
	bool marked = false;
	Counter bomb;
	
	DS(){ bomb = new Counter(this); }
	
	void mark(){ this.marked = true; }
	void unmark(){ this.marked = false; }
	
	void incCounter(){ bomb.tick(); }
	void decCounter(){ bomb.untick(); }
	bool get isDs => true;
}

abstract class dsAbstractNode<T> implements Comparable{
	T data;
	bool marked = false;
	
	void mark(){ this.marked = true; }
	void unmark(){ this.marked = false; }
	bool get isFree => (data == null);
	
	String toString(){
		return this.data.toString();
	}
}

abstract class dsTreeNode<T> extends dsAbstractNode<T>{
	dsTreeNode<T> left;
	dsTreeNode<T> right;
	dsTreeNode<T> root;
}

abstract class dsGSearcher{

}
	
abstract class dsGArc<N,T>{
	N node;
	T weight;
	
	dsGArc(this.node,this.weight);
}

abstract class dsGNode<T>{
	dsAbstractList<dsGArc> arcs;
	T data;
	
	dsGNode(this.data);
	
	void addArc(dsGNode<T> a,dynamic n);
	dsGNode find(dsGNode<T> n);
	bool arcExists(dsGNode<T> n);
	dsGArc arcFinder(dsGNode n,Function callback);
	
}
		
abstract class dsAbstractList<T> extends DS implements Comparable{
	dsAbstractNode<T> head;
	dsAbstractNode<T> tail;
	
	num get size => bomb.counter; 
	bool get isEmpty => (head == null && tail == null);
	dsAbstractIterator get iterator;	
	
}

abstract class dsAbstractIterator implements dsIteratorImpl,dsIteratorHelpers{
	static const int _uninit = 0;
	static const int _movin = 1;
	static const int _done = 2;
	int _state = 0;
	Counter counter;
	dsAbstractNode node;
	DS ds;
		
	dsAbstractIterator(this.ds){ counter = new Counter(this); }
	dsAbstractIterator createIterator(n);
	
	num get size{
		return this.ds.size;
	}
	
	String  get state{
		if(_state == _uninit) return "State::UnInitialized!";
		if(_state == _movin) return "State:Movable!";
		if(_state == _done) return "State::Done!";
	}
	
	dynamic get currentNode{
		if(this.node == null) return null;
		return this.node;	
	}
		
	dynamic get current{
		if(this.node == null) return null;
		return this.node.data;
	}
	
	bool move(Function init,Function change,Function reset){
		if(_state == _done){ reset(); this.reset(); }
		if(_state == _uninit){
			if(!init()) return false;
			_state = 1;
		}
		else if(_state == _movin){
			if(!change()){
				_state = _done; 
				return false;
			};
		}
		
		return true;
	}
	
	bool moveNext(){
		return this.move((){
			if(this.ds.root == null) return false;
			this.node = this.ds.root;
			return true;
		},(){
			if( this.node == null || this.node == this.ds.root || this.node.right == null) return false;
			this.node = this.node.right;		
			return true;
		},(){
			this.ds.root.unmarkCascade();
			return true;
		});
	}
	
	void reset(){
		this.node = null;
		_state = _uninit;
		this.counter.detonate();
	}
	
}
