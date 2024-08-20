//S4_Concatenation.java
class A{			
	public static void main(String[] args){
		System.out.println("Hello SJEC "+25);

		int date=25;
		System.out.println("Hello SJEC "+date);

		//operator overloading is not supported in Java
		//int to String
		System.out.print("Hello SJEC "+25+35);
		/*
			"Hello SJEC"+25 => "Hello SJEC"+"25"
				=> "Hello SJEC 25"+35
				=> "Hello SJEC 25"+"35"
				=> "Hello SJEC 2535"
		*/
		
		System.out.print(10+20+" Hello SJEC "+25+35);
		//20 Hello SJEC 2535

		/*
			//inbuilt method-overloading
			println(String s)
			println(int i)
			println(char i)
			println(double i)
			println(long i)
			println()
		*/

		System.out.println(10);	//10

		System.out.println();
		System.out.print();
		//neither printing nor other task
		//CTE:: method not found
	}
}