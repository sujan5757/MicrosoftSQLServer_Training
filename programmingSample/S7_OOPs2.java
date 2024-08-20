//S7_OOPs2.java

class A{
	public static int cName = "SJEC";

	public int usn;
	public String name;
	
	public static void m1(){
	}

	public void m2(){
		int d = 40;
		System.out.println("Loc var "+d);
		
		//non-static to static :: class-name not compulsory
		System.out.println("Static var "+cName);

		System.out.println("USN :: "+usn);
		System.out.println("Name :: "+name);

		//Conflicts with static variables::
		String cName = "SCEM and ALVA and CBIT and GRIET";
		System.out.println("CName loc :: "+cName);
		System.out.println("CName static :: "+A.cName);
		
		//Conflicts with non-static variables::
		int usn = 420;
		System.out.println("USN :: "+usn);	//420
		System.out.println("Non-static USN :: "+this.usn);

		//System.out.println("Non-static USN :: "+s1.usn);
		//CTE:: var 's1' not found
	}

	public static void main(String[] args){
		int e = 50;	//bytes
		System.out.println("Loc var "+e);
		System.out.println("College "+cName);

		//System.out.println("USN "+usn);
		//CTE:: variable not found
		//cannot access non-static variable directly from a method in static context


		//int age = 31
		//long[] mob = {41,31}
	
		//int,String,double s1 = {usn, name, marks};
		
		//user-defined data-type
		A s1 = new A();	//1001
		A s2 = new A();	//1002
		A s3 = new A();	//1003
		System.out.println("Non-static var "+s1.usn);
		System.out.println("Non-static var "+s1.name);

		//m2();
		//static to non-static :: addr is COMPULSORY
		s1.m2();
		
	}
}




