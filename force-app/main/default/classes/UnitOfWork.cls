public with sharing class UnitOfWork implements IUnitOfWork {
    private List<SObject> newRecords = new List<SObject>();

    public void registerNew(SObject record) {
        if (record != null) {
            newRecords.add(record);
        }
    }

    public void registerNew(List<SObject> records) {
        if (records != null && !records.isEmpty()) {
            newRecords.addAll(records);
        }
    }

    public void commitWork() {
        if (!newRecords.isEmpty()) {
            insert newRecords;
        }
    }
}