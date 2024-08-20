//S1_SrcByte.java
/*
	src code:: .java
	Compiler:: .java to .class

	exe code:: OS .exe

	============================================
	
	Source Code:: S1_SrcByte.java	:: JavaC
	Byte code  :: Student.class	:: JVM
	
	============================================

	Note:
	1. THe name of the byte code will be equal to name of the class used in the source code
	2. After compilation source code gets converted to byte code. Since it cannot run directly on the OS environment we use interpretor which creates a virtual environment to run the byte code.
*/

class Student{
	//only one copy
	public static String cName="SJEC";

	//multiple copies
	public int usn;
	public String name;
	public double cgpa;

	public static void main(String[] args){
		System.out.println("Hello "+cName);
	}
}