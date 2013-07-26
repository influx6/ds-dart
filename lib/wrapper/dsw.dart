library ds.wrapper;

part 'dswabstract.dart';
part 'dswmap.dart';
part 'dswlist.dart';

class dsWrapper<T,K>{
	
	static createMap(){
		return new dsWMapStorage<T,K>();
	}
	
	static createList(){
		return new dsWListStorage<T,K>();
	}
}



