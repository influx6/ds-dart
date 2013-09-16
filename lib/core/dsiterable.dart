part of ds.core;

class dsIterator extends dsAbstractIterator{
	
	dsIterator(ds): super(ds);
	dsIterator.Shell(): super.Shell();

	bool has(dynamic n){
		var self = this.ds.iterator;
		while(self.moveNext()){
			if(self.current != n) continue;
			return true;
			break;
		}
		return false;
	}

	bool compare(dsIterator l){
		if(this.size != l.size) return false;
		num matchCount = 0;
		var me = this.ds.iterator;
		
		while(l.moveNext()){
			if(me.has(l.current)) matchCount += 1;
		}
		
		if(matchCount == me.size) return true;
		return false;
	}
	
	dynamic get(dynamic n){
		var self = this.ds.iterator;
		while(self.moveNext()){
			if(self.current != n) continue;
			return n;
			break;
		}
		return;
	}
	
	List getAll(dynamic n){
		var self = this.ds.iterator,res = new List();
		while(self.moveNext()){
			if(self.current != n) continue;
			res.add(n);
		}
		return res;
	}
}

class dsListIterator extends dsIterator{
	
	static create(l){ return new dsListIterator(l); }
	dsListIterator(dsAbstractList l): super(l);
	
	dsListIterator createIterator(dsAbstractList l){
		return dsListIterator.create(l);
	}
	
	dynamic remove(dynamic l,{all:false}){
		var steps = dsListIterator.create(this.ds);
		var res;
		
		while(steps.moveNext()){
			if(steps.current != l) continue;
			res = steps.currentNode;
			var right = res.right;
			var left = res.left;

			if(right != null) left.right = right;
			if(left != null) right.left = left;
			if(steps.ds.head == res) steps.ds.head = right;
			if(steps.ds.tail == res) steps.ds.tail = left;
			
			res.right = res.left = null;
			if(all) res.free();
			steps.ds.decCounter(); 
			return res;
			if(!all) break;
		}
		
		steps.detonate();
	}
}

class dsSkipIterator extends dsIterator{
	dsIterator _it;
	num _skipCount;
	num _count;
	
	static create(ds,c){
		return new dsSkipIterator(ds,c);
	}
		
	dsSkipIterator(ds,count): super(ds){
		this._skipCount = this._count = count;
		_it = new dsIterator(ds);
	}
	
	bool moveNext([n]){
		for(var i =0; i < _skipCount; i++) this._it.moveNext();
		_skipCount = 0;
		return this._it.moveNext((){ _skipCount = _count; });
	}
	
	dynamic get current{
		return this._it.current;
	}
	
}

class dsSelectIterator extends dsIterator{
	final dsList phantom = new dsList();
	dsNode from;
	
  static create(dsNode m) => new dsSelectIterator(m);

	dsSelectIterator(dsNode d): super.Shell(){
    this.from = d;
    phantom.head = this.from;
    this.ds = phantom;
  }
  
  bool moveNext([n]){
    if(this.from == null || this.from.data == null) return false;
    return super.moveNext(n);
  }

  bool movePrevious([n]){
    if(this.from == null || this.from.data == null) return false;
    return super.movePrevious(n);
  }
}
