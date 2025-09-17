/**
 * @description Classe Batch Apex conçue pour traiter en masse les enregistrements de Compte,
 * par exemple pour un recalcul nocturne du chiffre d'affaires.
 */
global class UpdateAllAccounts implements Database.Batchable<sObject>{
    
    // La méthode start() définit la requête qui sélectionne les enregistrements à traiter.
    global Database.QueryLocator start(Database.BatchableContext info){ 
        //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Activated'
        return Database.getQueryLocator('SELECT Id FROM Account');
 
    }
     
    // La méthode execute() est appelée pour chaque lot de données et contient la logique métier.
    global void execute(Database.BatchableContext info, List<Account> scope){
        Set<Id> setAccountIds = (new Map<Id,SObject>(scope)).keySet();
        // Appeler une class qui va faire la logique du code;
    }    
     
    global void finish(Database.BatchableContext info){     
        
    } 
 }