public with sharing class CaseService {

    /**
     * Saves multiple cases to the database using UnitOfWork.
     * @param cases List of Case records to save.
     * @return Map<String, Object> containing success status and messages.
     */
    public static Map<String, Object> saveCases(List<Case> cases) {
        Map<String, Object> response = new Map<String, Object>();
        UnitOfWork uow = new UnitOfWork();

        try {
            // Register cases for insertion
            uow.registerNew(cases);

            // Commit the work
            uow.commitWork();

            response.put('isSuccess', true);
            response.put('message', 'Cases saved successfully.');
        } catch (Exception e) {
            response.put('isSuccess', false);
            response.put('message', e.getMessage());
        }
        return response;
    }
}