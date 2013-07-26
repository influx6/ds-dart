part of ds.core;

class dsCounter{
	num _count = 0;
	dynamic handler;
	
	dsCounter(this.handler);
	
	num get counter => _count;
	
	void tick(){
		_count += 1;
	}
	
	void untick(){
		_count -= 1;
	}
	
	void detonate(){
		_counter = 0;
	}
	
	String toString(){
		return this.counter.toString();
	}
}
	
class dsComparable{
	bool compare(dynamic d);
}

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
	void onUinit();
	void onMove();
	void onChange();
}
	
class dsIteratorImpl{
	
	void moveNext();
	dynamic get current;	
	
}

class DS implements dsImpl{
	bool marked = false;
	dsCounter bomb;
	
	DS(){ bomb = new dsCounter(this); }
	
	void mark(){ this.marked = true; }
	void unmark(){ this.marked = false; }
	
	void incCounter(){ bomb.tick(); }
	void decCounter(){ bomb.untick(); }
	bool get isDs => true;
}

abstract class dsAbstractNode implements dsComparable{
	dynamic data;
	bool marked = false;
	
	void mark(){ this.marked = true; }
	void unmark(){ this.marked = false; }
	bool get isFree => (data == null);
	
	String toString(){
		return this.data.toString();
	}
}

abstract class dsAbstractList<T> extends DS implements dsComparable{
	dsNode head;
	dsNode tail;
	
	num get size => bomb.counter; 
	bool get isEmpty => (head == null && tail == null);
	T get iterator;	
	
}

abstract class dsAbstractIterator implements dsIteratorImpl,dsIteratorHelpers{
	static const int _uninit = 0;
	static const int _movin = 1;
	static const int _done = 2;
	int _state = 0;
	dsCounter steps;
	dsAbstractNode node;
	DS ds;
		
	dsAbstractIterator(this.ds){ steps = new dsCounter(this); }
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
	
	bool moveNext(){
		if(_state == _done){ this.reset(); }
		if(_state == _uninit){
			_state = 1;
			this.onUinit();
		}
		else if(_state == _movin){
			this.onMove();
			if(this.node == this.ds.root || this.node == null ){ 
				_state = _done; 
				return false;
			}
		}
		
		this.steps.tick();
		return true;
	}
	
	void reset(){
		this.node = null;
		_state = _uninit;
		this.steps.detonate();
		this.onReset();
	}
	
	
}
