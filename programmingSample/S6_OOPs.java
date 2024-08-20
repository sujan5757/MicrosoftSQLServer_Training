//S6_OOPs

class A{
	//outside the methods
	public static int a = 10;
	public int b = 20;

	public static void m1(){
		//inside the methods
		int c = 30;
		System.out.println("Loc var "+c);
		System.out.println("Access static var "+a);

		//accessing local variable of caller
		//System.out.println("Loc caller :: "+e);
		//CTE:: var not found

		
	}

	public void m2(){
		int d = 40;
		System.out.println("Loc var "+d);
	}

	public static void main(String[] args){
		int e = 50;

		//accessing
		System.out.println("Loc var "+e);
		System.out.println("Access static var "+a);

		//conflict
		int a = 200;
		System.out.println("Loc var "+a);
		System.out.println("Access static var "+A.a);
		
		m1();
		A.m1();
		//anything static I can access using class-name

		//accessing local variable of callee
		//System.out.println("Loc callee :: "+c);
		//CTE:: var not found

	}
}

/*
	Types of variables::
		static, non-static, local
	Why main() must be static::
	
	Static methods::
		1. can create and access local var directly
		2. can access another static variable directly
		3. If in case of a conflict
			=> in order to access static variable we need to mention class name

	Accessing local variables::
	By caller :: already they will be destroyed :: CTE 
	By Callee :: LIFO :: CTE

	Learning::
	Local variables cannot be accessed outside their method scope

	Life-cycle of a local variable::
	1. Gets created in stack memory in method scope
	2. Can be accessed only by the corresponding method
	3. Will be destroyed before the method goes out of stack
	================================================

	System.out

	public class System{
		public static _____ out = ____;
	}

	================================================

*/