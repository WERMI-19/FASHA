/**
 * @description Controller Apex pour composants LWC. Le 'without sharing' est utilisé
 * pour garantir que le calcul du total inclut toutes les commandes pertinentes.
 */
public without sharing class OrdersController {
    
    /**
     * @description Calcule la somme des commandes activées pour un compte donné.
     * @param accountId L'ID du compte client.
     * @return Le montant total (Decimal) ou 0 si aucun.
     */
    @AuraEnabled(cacheable=true)
    public static Decimal getSumOrdersByAccount(Id accountId) {
        if (accountId == null) {
            return 0;
        }

        // Requête SOQL d'agrégation pour sommer  les montants côté base de données.
        AggregateResult groupedResult = [
            SELECT SUM(TotalAmount) total 
            FROM Order 
            WHERE AccountId = :accountId AND Status = 'Activated'
        ];
        
        // Gère le cas où aucune commande ne correspond, car SUM() retourne alors null.
        if (groupedResult != null && groupedResult.get('total') != null) {
            return (Decimal)groupedResult.get('total');
        }
        
        return 0;
    }

}