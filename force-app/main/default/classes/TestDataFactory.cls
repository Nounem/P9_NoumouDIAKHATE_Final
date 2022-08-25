/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactory{

public static Account createAccount2(String name) {
    Account account = new Account( Name = name);
    insert account;
    return account;
}


public static List<Order> createAccountWithOrders(Integer numberOrders, Id accountId){
        
    List<Order> orders = new List<Order>();
    for(Integer i=0; i<numberOrders; i++) {
        Order order = new Order(
            AccountId = accountId,
            Pricebook2Id = Test.getStandardPricebookId(),
            status = 'draft',
            ShipmentCost__c = 20, 
            effectiveDate = Date.today()
        );
        orders.add(order);
    }
    insert orders;

    Product2 product2 = new Product2(
        Name = 'ProductTest',
        Family = 'family',
        IsActive = true
    );
    insert product2;

    PricebookEntry pricebookEntry = new PricebookEntry(
        Pricebook2Id = Test.getStandardPricebookId(),
        Product2Id = product2.Id,
        UnitPrice = 200, 
        IsActive = true
    );
    insert pricebookEntry; 
    
    List<OrderItem> items = new List<OrderItem>();
    for(Order order: orders) {
        OrderItem item = new OrderItem (OrderId = order.Id, PricebookEntryId = pricebookEntry.Id, Quantity=1, UnitPrice = 200);
        items.add(item);
    }
    insert items;     
    
    update orders;
    return orders;
}   

}
