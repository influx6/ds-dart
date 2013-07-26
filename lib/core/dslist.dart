part of ds.core;

class dsListIterator extends dsIterable{
	
	static create(l){ return new dsListIterator(l); }
	dsListIterator(dsList l): super(l);
	
	dsListIterator createIterator(dsList l){
		return dsListIterator.create(l);
	}
	
	void onUinit(){
		if(this.ds.root == null) return;
		this.node = this.ds.root;
	}
	
	void onMove(){
		if(this.node.right == null) return;
		this.node = this.node.right;
	}
	
	void onReset(){
		this.ds.root.unmarkCascade();
	}
	
	bool remove(dynamic l){
		var steps = dsListIterator.create(this.ds);
		var res;
		
		while(steps.moveNext()){
			if(steps.current != l) continue;
			res = steps.currentNode;
			var right = res.right;
			var left = res.left;
			left.right = right;
			right.left = left;
			
			res.right = res.left = null;
			return true;
			break;
		}
	}
}

class dsList extends dsAbstractList<dsListIterator>{
	num _maxSize;
	
	static create(){
		return new dsList();
	}
	
	void append(dynamic d){
		if(this.isEmpty){ this.head = this.tail = dsNode.create(d); return this.incCounter();}
		var tail = this.tail;
		var left = tail.left;
		
		this.tail = dsNode.create(d);
		this.tail.right = this.head;
		this.tail.left = tail;
		
		tail.right = this.tail;		
		return this.incCounter();
	}
	
	void prepend(dynamic d){
		if(this.isEmpty){ this.head = this.tail = dsNode.create(d); return this.incCounter();}
		var head = this.head;
		var left = head.left;
		var right = head.right;
		
		this.head = dsNode.create(d);
		this.head.right = head;
		this.head.left = this.tail;
		
		head.left = this.head;
		return this.incCounter();
	}
	
		
	bool isDense(){
		if(this.size < this._maxSize) return false;
		this.close();
	}
	
	void free(){ 
		this.head.freeCascade();	
		this.head.unmarkCascade();
	}
		
	dsNode get root => this.head;
	dsListIterator get iterator => dsListIterator.create(this);
}