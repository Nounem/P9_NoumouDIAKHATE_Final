/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-08-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger UpdateAccountTotalRevenue on Order ( after update) 
{
        HandlerAccount.updateAccountCA ( Trigger.newMap);

}
