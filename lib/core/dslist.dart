part of ds.core;

class dsList<T> extends dsAbstractList{
	num _maxSize;
	dsListIterator _it;
	
	static create([n]){
		return new dsList(n);
	}
	
	dsList([List data]){
		if(data != null) data.forEach((n){ this.append(n); });
		this._it = dsListIterator.create(this);
	}
	
	dsNode append(T d){
		if(this.isEmpty){ 
      this.head = this.tail = dsNode.create(d); 
      this.incCounter();
      return this.tail;
    }
		var tail = this.tail;
		var left = tail.left;
		var right = tail.right;
		
		this.tail = dsNode.create(d);
		this.tail.right = this.head;
		this.tail.left = tail;
		
		tail.right = this.tail;		
		this.head.left = this.tail;
		
		this.incCounter();
    return this.tail;
	}
	
	dsNode prepend(T d){
		if(this.isEmpty){ 
      this.head = this.tail = dsNode.create(d); 
      this.incCounter();
      return this.head;
    }
		var head = this.head;
		var left = head.left;
		var right = head.right;
		
		this.head = dsNode.create(d);
		this.head.right = head;
		this.head.left = this.tail;
		
		head.left = this.head;
		this.incCounter();
    return this.head;
	}
	
	dynamic removeHead(){
    if(this.isEmpty) return;
		var head = this.root;
		var left = head.left;
		var right = head.right;
		
		this.head = right;
		this.head.left = left;
		left.right = this.head;
		
		head.right = head.left = null;
		this.decCounter();
		return head;
	}
	
	dynamic removeTail(){
    if(this.isEmpty) return;
		var tail = this.tail;
		var left = tail.left;
		var right = tail.right;
		
		this.tail = left;
		this.tail.right = this.head;
		left.right = this.tail;
		
		tail.right = tail.left = null;
		
		this.decCounter();
		return tail;	
	}
	
	dynamic remove(T d){
    if(this.isEmpty) return;
    var i = this._it.remove(T);
	if(i != null) this.decCounter();
    return i;
	}
	
	void removeAll(){
    if(this.isEmpty) return;
	  this.free();
	  this.head = this.tail = null;
	}

	bool isDense(){
		if(this.size < this._maxSize) return false;
	}
	
	void free(){ 
    if(this.isEmpty) return;
		this.head.freeCascade();	
		this.head.unmarkCascade();
	}
		
	dsNode get root => this.head;
  	bool  get isEmpty => (this.head == null && this.tail == null);
	dsListIterator get iterator => dsListIterator.create(this);
}
