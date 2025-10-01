/**
 * Contrôleur pour le composant LWC accountOrdersSummary
 * Gestion des données de commandes par compte
 */
public with sharing class OrdersController {
    
    /**
     * Calcule le total des commandes activées pour un compte
     * @param accountId ID du compte
     * @return Somme totale des commandes activées
     */
    @AuraEnabled(cacheable=true)
    public static Decimal getSumOrdersByAccount(Id accountId) {
        if (accountId == null) {
            return 0;
        }

        // Récupère directement la somme depuis la base
        AggregateResult groupedResult = [
            SELECT SUM(TotalAmount) total 
            FROM Order 
            WHERE AccountId = :accountId AND Status = 'Activated'
        ];
        
        // Retourne la somme ou 0 si aucun résultat
        return (Decimal)groupedResult.get('total') != null ? (Decimal)groupedResult.get('total') : 0;
    }
}