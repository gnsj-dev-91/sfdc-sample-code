@isTest
public with sharing class HelloWorldTest {
    @isTest
    static void checkMessage() {
        String name = 'Jeff';

        HelloWorld myHelloWorld = new HelloWorld();
        String message = myHelloWorld.hey(name);

        System.assertEquals('How are you Jeff?', message);
    }
}
