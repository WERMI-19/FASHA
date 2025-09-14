public without sharing class OrdersController {
    
    @AuraEnabled(cacheable=true)
    public static Decimal getSumOrdersByAccount(Id accountId) {
        if (accountId == null) {
            return 0;
        }

        AggregateResult groupedResult = [
            SELECT SUM(TotalAmount) total 
            FROM Order 
            WHERE AccountId = :accountId AND Status = 'Activated'
        ];
        
        if (groupedResult != null && groupedResult.get('total') != null) {
            return (Decimal)groupedResult.get('total');
        }
        
        return 0;
    }

}