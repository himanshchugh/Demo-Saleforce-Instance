public with sharing class testClass2 {
	

	public testClass2() {
		testClass.testInnerClass innerObj = new testClass.testInnerClass();
		innerObj.testProp1 = 'abc';
		system.debug(innerObj.testProp1);
	}


}