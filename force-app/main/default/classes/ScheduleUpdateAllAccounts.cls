global class ScheduleUpdateAllAccounts implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateAllAccounts());
    }
    
}