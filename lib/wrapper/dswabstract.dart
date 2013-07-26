part of ds.wrapper;

class dsWImpl{
	K get(T t);
	void set(T n,K k);
	k delete(T n);
}

class dsWAbstract<V,T,K> extends dsWrapper implements dsWImpl{
	V store;
}