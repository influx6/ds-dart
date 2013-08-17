part of ds.specs;

void searcher(){
	
  	var graph = ds.dsGraph.create();
  	
  	var n1 = graph.add(1);
  	var n2 = graph.add(2);
	var n3 = graph.add(3);
  	var n4 = graph.add(4);
	var n5 = graph.add(10);
	var n6 = graph.add(15);
	
  	graph.bind(n3,n2,1);
  	graph.bind(n1,n5,8);
  	graph.bind(n1,n6,3);
  	graph.bind(n4,n2,2);
  	graph.bind(n2,n4,2);
  	graph.bind(n2,n6,12);
  	graph.bind(n5,n3,5);
	graph.bind(n6,n4,3);
	
	var df = ds.dsDepthFirst.create((n,[a]){
		print('depth-first processing $n : $a');
	});
	var bf = ds.dsBreadthFirst.create((n,[a]){
		print('breadth-first processing $n : $a');
	});
	
	df.search(graph);
	print('\n');
	bf.search(graph);
}