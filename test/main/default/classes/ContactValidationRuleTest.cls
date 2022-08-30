@isTest
public with sharing class ContactValidationRuleTest {
  @isTest
  public static void testUserClientRelation() {
    Contact c = new Contact(
      LastName = 'Test1',
      LoginEmail__c = 'test1@example.com',
      ContactType__c = 'Survey Client');
    insert c;
    Contact u = new Contact(
      LastName = 'Test2',
      LoginEmail__c = 'test2@example.com',
      ContactType__c = 'Field Worker');
    insert u;
    insert new FieldWorkerClientRelation__c(
      Client__c = c.Id,
      FieldWorker__c = u.Id
    );  
    System.assert([SELECT COUNT() FROM FieldWorkerClientRelation__c] > 0, 'relationship record is not created.');
  }

    @isTest
    public static void testSurveyUserFieldRestriction() {
      Contact c = new Contact(
        LastName = 'Test',
        LoginEmail__c = 'test@example.com',
        ContactType__c = 'Survey Client');
      insert c;
      String message;
      try {
        insert new FieldWorkerClientRelation__c(
          Client__c = c.Id,
          FieldWorker__c = c.Id
        );
      } catch (Exception e) {
        message = e.getMessage();
      }
      System.assert(!String.isBlank(message), 'validation rule for field worker filed is not working');
      System.assert(message.contains('You must specify &quot;Field Worker&quot; type contact for the Field Worker field.'), 'message of validation rule for field worker filed is wrong');
    }

    @isTest
    public static void testSurveyClientFieldRestriction() {
      Contact c = new Contact(
        LastName = 'Test',
        LoginEmail__c = 'test@example.com',
        ContactType__c = 'Field Worker');
      insert c;
      String message;
      try {
        insert new FieldWorkerClientRelation__c(
          Client__c = c.Id,
          FieldWorker__c = c.Id
        );
      } catch (Exception e) {
        message = e.getMessage();
      }
      System.assert(!String.isBlank(message), 'validation rule for survey client filed is not working');
      System.assert(message.contains('You must specify &quot;Survey Client&quot; type contact for the Survey Client field.'), 'message of validation rule for survey client filed is wrong');
    }
}