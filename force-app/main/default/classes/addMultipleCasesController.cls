public with sharing class addMultipleCasesController {

    /**
     * Saves multiple cases by delegating to the CaseService.
     * @param cases List of Case records to save.
     * @return Map<String, Object> containing success status and messages.
     */
    @AuraEnabled
    public static Map<String, Object> saveMultipleCases(List<Case> cases) {
        return CaseService.saveCases(cases);
    }
}


