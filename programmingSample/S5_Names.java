//S5_Names.java

/*
	class		:: System		AccountBalance
	variable 	:: out			accountBalance
	method		:: println()		accountBalance()
*/

class A{
	public static void main(String[] args){
		int i = 10;
		int i20 = 10;
		//int 20i = 10;	//invalid
		
		//location of special characters
		int _i20 = 10;
		int i_20 = 10;
		int i20_ = 10;

		int $i20 = 10;
		int $20 = 10;

		int __i20 = 10;
		int __20 = 10;
		int __ = 10;

		
		//RHS
		i = 97434;
		System.out.println(i);

		i = 97_434;
		System.out.println(i);	//

		//i = 97434_;
		//CTE:: illegal underscore

		//int x = 10;
		//int y = x;	//CTE:: var not found

		i = _97434;
		//CTE:: var not found
	}
}





