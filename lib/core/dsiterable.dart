part of ds.core;

class dsIterable extends dsAbstractIterator{
	
	dsIterable(d) : super(d);
		
	bool has(dynamic n){
		var self = this.ds.iterator;
		while(self.moveNext()){
			if(self.current != n) continue;
			return true;
			break;
		}
		return false;
	}

	bool compare(dsIterable l){
		if(this.size != l.size) return false;
		num matchCount = 0;
		var me = this.ds.iterator;
		
		while(l.moveNext()){
			if(me.has(l.current)) matchCount += 1;
		}
		
		if(matchCount == me.size) return true;
		return false;
	}

}

class dsSkipIterator extends dsIterable{
	var _skipCount;
	var _count;
	dsIterable _it;
	
	static create(ds,c){
		return new dsSkipIterable(ds,c);
	}
	
	dsSkipIterable(ds,count): super(ds){
		if(count > ds.size) throw new Exception('SkipCount is more than elements available!');
		_count = _skipCount = count;
		this._it = new dsIterable(ds);
	}
	
	dynamic get current{
		if(this._it.node == null) return null;
		return this._it.node.data;
	}
	
	bool moveNext([n]){
		for(var i =0; i < _skipCount; i++) this._it.moveNext();
		_skipCount = 0;
		return this._it.moveNext((){ this.reset(); });
	}
	
	void onReset(){
		_skipCount = _count;
	}
	
}

class dsSelectIterator extends dsIterable{
	
}