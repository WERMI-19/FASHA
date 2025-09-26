/**
 * @description Classe Batch Apex conçue pour traiter en masse les enregistrements de Compte,
 * par exemple pour un recalcul nocturne du chiffre d'affaires.
 */
global class UpdateAccountsBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext info){ 
        return Database.getQueryLocator('SELECT Id FROM Account');
 
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){
        Set<Id> setAccountIds = (new Map<Id,SObject>(scope)).keySet();
        // Appeler une class qui va faire la logique du code;
    }    
     
    global void finish(Database.BatchableContext info){     
        
    } 
 }