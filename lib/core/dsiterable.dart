part of ds.core;

abstract class dsIterable extends dsAbstractIterator{
	
	dsIterable(ds): super(ds);
		
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

abstract class dsSkipIterable extends dsIterable{
	
	dsSkipIterable(ds): super(ds);
	
	bool moveNext(){
		var p = this.super.moveNext();
		return p;
	}
}