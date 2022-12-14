/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-20-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class MyTeamOrdersController 
{
    public List<AggregateResult> aggregateResultList{get;set;}

    public MyTeamOrdersController() 
    {
        aggregateResultList = new List<AggregateResult>();
        aggregateResultList = [SELECT count(id) ordCount, sum(TotalAmount) ordSum, owner.Name ordName 
                               FROM Order 
                               WHERE Status ='Ordered' GROUP BY owner.Name
                            ];
                            
    }  
}