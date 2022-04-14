@isTest
public with sharing class GRMS_ContactValidationRuleTest {
  @isTest
  public static void testUserClientRelation() {
    Contact c = new Contact(
      LastName = 'Test1',
      GRMS_LoginEmail__c = 'test1@example.com',
      GRMS_ContactType__c = 'Survey Client');
    insert c;
    Contact u = new Contact(
      LastName = 'Test2',
      GRMS_LoginEmail__c = 'test2@example.com',
      GRMS_ContactType__c = 'Survey User');
    insert u;
    insert new GRMS_UserClientRelation__c(
      GRMS_Client__c = c.Id,
      GRMS_User__c = u.Id
    );  
    System.assert([SELECT COUNT() FROM GRMS_UserClientRelation__c] > 0, 'relationship record is not created.');
  }

    @isTest
    public static void testSurveyUserFieldRestriction() {
      Contact c = new Contact(
        LastName = 'Test',
        GRMS_LoginEmail__c = 'test@example.com',
        GRMS_ContactType__c = 'Survey Client');
      insert c;
      String message;
      try {
        insert new GRMS_UserClientRelation__c(
          GRMS_Client__c = c.Id,
          GRMS_User__c = c.Id
        );
      } catch (Exception e) {
        message = e.getMessage();
      }
      System.assert(!String.isBlank(message), 'validation rule for user filed is not working');
      System.assert(message.contains('You must specify &quot;Survey User&quot; type contact for the user field.'), 'message of validation rule for user filed is wrong');
    }

    @isTest
    public static void testSurveyClientFieldRestriction() {
      Contact c = new Contact(
        LastName = 'Test',
        GRMS_LoginEmail__c = 'test@example.com',
        GRMS_ContactType__c = 'Survey User');
      insert c;
      String message;
      try {
        insert new GRMS_UserClientRelation__c(
          GRMS_Client__c = c.Id,
          GRMS_User__c = c.Id
        );
      } catch (Exception e) {
        message = e.getMessage();
      }
      System.assert(!String.isBlank(message), 'validation rule for user filed is not working');
      System.assert(message.contains('You must specify &quot;Survey Client&quot; type contact for the client field.'), 'message of validation rule for user filed is wrong');
    }
}