@isTest
public class AnimalLocatorTest {

    @isTest
    static void testGetAnimalById() {
        //Create Mock Object
        //Set up mock
       	Test.setMock(HttpCallOutMock.class, new AnimalLocatorMock());
        String animalName = AnimalLocator.getAnimalNameById(2);
        System.assertEquals('bear', animalName);
    }
}