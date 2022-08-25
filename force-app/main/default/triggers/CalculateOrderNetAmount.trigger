/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger CalculateOrderNetAmount on Order (before update) 
{
    /** 
    HandlerAccount.updateNetAmount(Trigger.new);
    System.debug('Trigger.new'+Trigger.new);
    */

    for (Order newOrder : Trigger.new) {
        // Calculate net amount  and substract or not total amount with shipment cost
        newOrder.NetAmount__c = newOrder.ShipmentCost__c == null ? newOrder.TotalAmount: newOrder.TotalAmount - newOrder.ShipmentCost__c;

        System.debug('Trigger.new newOrder.NetAmount__c '+newOrder.NetAmount__c);
    }


}