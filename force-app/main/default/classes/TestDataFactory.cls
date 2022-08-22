/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-20-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestDataFactory{


public static void createAccounts( Integer nbAccounts)
{
    List<Order> orders = new List<Order>();
    List<OrderItem> ordItems = new List<OrderItem>();
    List<Account> accountList = new List<Account>();

    for (Integer i=0;i< nbAccounts;i++) {

        Account acct = new Account(Name = 'TestAccount'+i);   
        accountList.add(acct);
    }
    
    insert accountList;
    
    for (Account acc : accountList) {

        orders.add(new Order(
            AccountId = acc.Id,
            Pricebook2Id = Test.getStandardPricebookId(),
            Status = 'Draft',
            ShipmentCost__c = 20, 
            EffectiveDate = System.today()
        )
      );

    }
    insert orders;

    Product2 pd = new Product2(
                                Name = 'ProductTest',
                                Family = 'family',
                                IsActive = true
                            );
    insert pd;

    PricebookEntry pbe = new PricebookEntry(
                                            Pricebook2Id = Test.getStandardPricebookId(),
                                            Product2Id = pd.Id,
                                            UnitPrice = 50000, 
                                            IsActive = true
                                        );
    insert pbe;

    for (Order o : orders)
    {
            ordItems.add(new OrderItem(
                                        OrderId = o.Id,
                                        PriceBookEntryId = pbe.Id,
                                        Quantity = 10, 
                                        UnitPrice = 200
                                    )
                        );
            ordItems.add(new OrderItem(
                            OrderId = o.Id,
                            PriceBookEntryId = pbe.Id,
                            Quantity = 20, 
                            UnitPrice = 1000
                        )
            );
    }

    insert ordItems;
  //  orders[0].Status = 'Ordered';
 //   update orders;

}

}
