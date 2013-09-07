part of ds.core;

class dsDepthFirst extends dsGSearcher{
	
	static create(d) => new dsDepthFirst(d);

	dsDepthFirst(Function processor(dsGraphNode b,[dsGraphArc a])): super(processor);
	
	
	void search(dsAbstractGraph g,[Function heuristic]){
		if(!this.isReady(g)) return;
				
		this.processArcs(dsGraphArc.create(g.root.data,null),heuristic);
		g.clearMarks();
	}
	
	void processArcs(dsGraphArc a,[Function heuristic]){
		if(a == null || a.node == null) return;
		
		var n = a.node;
		this.processor(n,a);
		n.mark();
		var arc = n.arcs.iterator;
		while(arc.moveNext()){
			if(!arc.current.node.marked) 
				this.processArcs(arc.current,heuristic);
		}
	}

}

class dsLimitedDepthFirst extends dsDepthFirst{
    num depth = -1;

    static create(d) => new dsLimitedDepthFirst(d);

    dsLimitedDepthFirst(d):super(d);
    
    void search(dsAbstractGraph g,[num depth,Function heuristic]){
      this.depth = ((depth != null && depth != 0) ? depth : -1);
      super.search(g,heuristic);
    }

    void processArcs(dsGraphArc a,[Function heuristic]){
      if(this.depth == 0) return;
      
      if(this.depth != -1) this.depth -= 1;
      super.processArcs(a,heuristic);
    }
}


class dsLimitedBreadthFirst extends dsBreadthFirst{
    num depth = -1;

	static create(d) => new dsLimitedBreadthFirst(d);
	
	dsLimitedBreadthFirst(Function processor(dsGraphNode b,[dsGraphArc a])): super(processor);
	
	void search(dsAbstractGraph g,[num depth,Function heuristic]){
		if(!this.isReady(g)) return;
    this.depth = ((depth != null && depth != 0) ? depth : -1);

		this.processArcs(dsGraphArc.create(g.root.data,null),heuristic);
		g.clearMarks();
		
	}
	
	void processArcs(dsGraphArc a,[Function heuristic]){
		if(a == null || a.node == null) return;
    if(this.depth == 0){ this.depth = -1; return; }
      
		
		var queue = new Queue();
		queue.add(a);
		queue.first.node.mark();
		while(queue.isNotEmpty){
      if(this.depth == 0) break;
			this.processor(queue.first.node,queue.first);
			var arc = queue.first.node.arcs.iterator;
			while(arc.moveNext()){
				if(!arc.current.node.marked){
					queue.add(arc.current);
					arc.current.node.mark();
				}
			}
			queue.removeFirst();
      this.depth -= 1;
		}
	}


}

class dsBreadthFirst extends dsGSearcher{

	static create(d) => new dsBreadthFirst(d);
	
	dsBreadthFirst(Function processor(dsGraphNode b,[dsGraphArc a])): super(processor);
	
	void search(dsAbstractGraph g,[Function heuristic]){
		if(!this.isReady(g)) return;
				
		this.processArcs(dsGraphArc.create(g.root.data,null),heuristic);
		g.clearMarks();
		
	}
	
	void processArcs(dsGraphArc a,[Function heuristic]){
		if(a == null || a.node == null) return;
		
		var queue = new Queue();
		queue.add(a);
		queue.first.node.mark();
		while(queue.isNotEmpty){
			this.processor(queue.first.node,queue.first);
			var arc = queue.first.node.arcs.iterator;
			while(arc.moveNext()){
				if(!arc.current.node.marked){
					queue.add(arc.current);
					arc.current.node.mark();
				}
			}
			queue.removeFirst();
		}
	}


}

class dsGraph<T,M> extends dsAbstractGraph<T,M>{
    
    dynamic git;

    static create() => new dsGraph<T,M>();
    

    dsGraph(): super(){
      this.nodes = new dsList<dsGNode<T,M>>();
      this.git = this.nodes.iterator;
    }
    
    dsGraphNode add(dynamic data){
      if(data is dsGraphNode) return this.nodes.append(data).data;
      return this.nodes.append(dsGraphNode.create(data)).data;
    }
    
    void bind(dsGraphNode<T,M> from,dsGraphNode<T,M> to,dynamic weight){
      from.addArc(to,weight);
      if(!this.git.has(from)) this.add(from);
      if(!this.git.has(to)) this.add(to);
    }
  
    void unbind(dsGraphNode<T,M> from,dsGraphNode<T,M> to){
      from.removeArc(to);
      if(!this.git.has(from)) this.add(from);
      if(!this.git.has(to)) this.add(to);
    }

    
    void eject(dsGraphNode<T,M> to){
      while(this.git.moveNext()){
        this.git.current.removeArc(to);
      }
    }
	
    void clearMarks(){
      while(this.git.moveNext()){
        this.git.current.unmark();
      }
    }
    
    String toString(){
      var map = new StringBuffer();
      map.write("<GraphMap:\n");
      while(this.git.moveNext()){
        map.write('<Edge:<');
        map.write(this.git.current.printArcs());
        map.write('>>');
      }
      map.write('>');
      return map.toString();
    }
}

class dsGraphArc<T> extends dsGArc<dsGraphNode,T>{
	
	static create(n,w){
		return new dsGraphArc(n,w);
	}
	
	dsGraphArc(node,weight) : super(node,weight);

  String toString(){
    return "Arc: Node data ${this.node.data}, Weight: ${this.weight}";
  }
}

class dsGraphNode<T,M> extends dsGNode<T,M>{
	var _dit;
  	bool isUniq = true;
	
	static create(n,{bool unique: true}){
		return new dsGraphNode(n,unique: unique);
	}
	
	dsGraphNode(data,{bool unique: true}): super(data){
		this.arcs = new dsList<dsGraphArc<M>>();
		this._dit = this.arcs.iterator;
    this.isUniq = unique;
	}
	
	void addArc(dsGraphNode a,dynamic n){
		if(!this.isUniq) { 
      this.arcs.append(new dsGraphArc(a,n));
      return;
    }
    this.probe(a,(m){
      if(m == null) return this.arcs.append(new dsGraphArc(a,n));
    });
	}
	
	dsGraphArc findArc(dsGraphNode n){
		return this.arcFinder(n,(m){
			return m;
		})
	}
	
	dsGraphArc removeArc(dsGraphNode n){
		return this.arcFinder(n,(m){
      this._dit.remove(m);
      m.node.removeArc(this);
			return m;
		});
		
	}
	
	dsGraphArc removeAllArch(dsGraphNode n){
		return this.arcFinder(n,(m){
			return this._dit.remove(m,all:true);
		});
	}
	
	bool removeAllArchs(){
		return this.arcs.removeAll();
	}
		
	bool arcExists(dsGraphNode n,[Function m]){
		return this.arcFinder(n,(m){
			return true;
		});
	}
	
   dsGraphArc arcFinder(dsGraphNode n,Function callback){
    	this.probe(n,(m){
      		if(m != null) return callback(m);
    	});
   }

   dynamic probe(dsGraphNode n,Function callback){
     var itr = this.arcs.iterator;
		while(itr.moveNext()){
			if(!itr.current.node.compare(n)) continue;
			return callback(itr.current);
			break;
		}
     return callback(null);
   }


   String printArcs(){
     var buffer = new StringBuffer();
     buffer.write('Node: ${this.data} with Arcs: ${this.arcs.size}');
     buffer.write('\n');
     while(this._dit.moveNext()){
      buffer.write("<");
      buffer.write(this._dit.current.toString());
      buffer.write('>\n');
     }
     return buffer.toString();
   }
}
