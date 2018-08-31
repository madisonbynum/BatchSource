package com.revature.design;
/*
 * Singleton Design Pattern
 * ensures a class has only one instance and provides a global
 * point of access to it
 */
public class Singleton {
	//static provate porpery of the self class
	private static Singleton instance;
	//Private constuctor
	private Singleton() {
		//logic here
	}
	//static method to get the unique instance,where it
	//creates the instance if has not been created
	public static synchronized Singleton getInstance() {
		if (instance ==null) {
			instance = new Singleton();
			return instance;	
		}
		return instance;
	}
	
	public void doSomething() {
		//what the object should do.
	}
	
}
