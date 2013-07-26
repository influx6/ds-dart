library ds.specs;

import 'package:ds/ds.dart' as ds;
	
void main(){

	var node = ds.dsNode.create(2);		
	var list = ds.dsList.create();
	var liss = ds.dsList.create();
	var li = list.iterator;
	var ls = liss.iterator;
	
	list.append(1);
	list.append(2);
	list.append(3);
	list.append(4);
	list.append(5);
	
	liss.append(1);
	liss.append(2);
	liss.append(3);
	liss.append(4);
	liss.append(5);
	
	assert(li.has(1));
	assert(li.has(2));
	assert(li.has(4));
	assert(li.has(3));
	assert(!li.has(6));	
	
	assert(li.compare(liss.iterator));
	
	assert(ls.remove(2));
	assert(!ls.has(2));
	
}
