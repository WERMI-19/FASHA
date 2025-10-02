/**
 * Classe utilitaire pour mesurer les performances
 */
public class PerformanceMetrics {
    public Map<String, Long> startTimes = new Map<String, Long>();
    public Map<String, Long> executionTimes = new Map<String, Long>();
    public Map<String, Integer> counters = new Map<String, Integer>();
    
    public void startTimer(String operationName) {
        startTimes.put(operationName, System.now().getTime());
    }
    
    public void stopTimer(String operationName) {
        Long startTime = startTimes.get(operationName);
        if (startTime != null) {
            Long endTime = System.now().getTime();
            executionTimes.put(operationName, endTime - startTime);
        }
    }
    
    public void incrementCounter(String counterName, Integer increment) {
        Integer currentValue = counters.get(counterName) != null ? counters.get(counterName) : 0;
        counters.put(counterName, currentValue + increment);
    }
    
    public void incrementCounter(String counterName) {
        incrementCounter(counterName, 1);
    }
    
    public void logPerformance() {
        System.debug('=== PERFORMANCE METRICS ===');
        
        // Log des temps d'exécution
        for (String operation : executionTimes.keySet()) {
            System.debug(operation + ' : ' + executionTimes.get(operation) + 'ms');
        }
        
        // Log des compteurs
        for (String counter : counters.keySet()) {
            System.debug(counter + ' : ' + counters.get(counter));
        }
        
        // Log des limites Salesforce
        System.debug('=== SALESFORCE LIMITS ===');
        System.debug('SOQL Queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        System.debug('DML Statements: ' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements());
        System.debug('CPU Time: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime());
        System.debug('Query Rows: ' + Limits.getQueryRows() + '/' + Limits.getLimitQueryRows());
        System.debug('DML Rows: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows());
        System.debug('Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
    }
    
    public void reset() {
        startTimes.clear();
        executionTimes.clear();
        counters.clear();
    }
}