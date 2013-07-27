part of ds.specs;

void graphSpec(){
	
	var arc = ds.dsGraphArc.create(ds.dsGraphNode.create(1),1);
	assert(arc.node.data == 1);
	assert(arc.weight == 1);
	
	var node = ds.dsGraphNode.create(1);
	node.addArc(ds.dsGraphNode.create(1),1);
	node.addArc(ds.dsGraphNode.create(2),2);
	
	
}