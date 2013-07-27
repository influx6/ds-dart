part of ds.core;

class dsDeptFirst extends dsGSearcher{

}

class dsBreadthFirst extends dsGSearcher{

}
	
class dsGraphArc<T> extends dsGArc<dsGraphNode,T>{
	
	static create(n,w){
		return new dsGraphArc(n,w);
	}
	
	dsGraphArc(n,w) : super(n,w);

}

class dsGraphNode<T,M> extends dsGNode<T>{
	var _dit;
	
	static create(n){
		return new dsGraphNode(n);
	}
	
	dsGraphNode(data): super(data){
		arcs = new dsList<dsGraphArc<M>>();
		_dit = arcs.iterator;
	}
	
	void addArc(dsGraphNode a,dynamic n){
		this.arcs.append(new dsGraphArc(a,n));
	}
	
	dsGraphArc findArc(dsGraphNode<T> n){
		return this.arcFinder(n,(m){
			return m;
		})
	}
	
	dsGraphArc removeArch(dsGraphNode<T> n){
		return this._dit.remove(n);
	}
	
	dsGraphArc removeAllArch(dsGraphNode<T> n){
		return this._dit.remove(n,all:true);
	}
	
	bool removeAllArchs(){
		return this.arcs.removeAll();
	}
		
	bool arcExists(dsGNode<T> n){
		return this.arcFinder(n,(m){
			return true;
		});
	}
	
	dsGraphArc arcFinder(dsGNode<T> n,Function callback){
		while(this._dit.moveNext()){
			if(itr.current.node != n) continue;
			return callback(itr.current);
			break;
		}
	} 
	

}