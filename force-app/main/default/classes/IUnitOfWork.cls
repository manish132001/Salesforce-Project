public interface IUnitOfWork {
    void registerNew(SObject record);
    void registerNew(List<SObject> records);
    void commitWork();
}