public with sharing class InfiniteLoading {
    @AuraEnabled(cacheable=true)
    public static List<Account> InfiniteLoadingMethod(Integer limitSize, Integer offsetSize) {
        List<Account> accList=[Select Id, Name FROM Account limit :limitSize Offset :offsetSize];
        System.debug('acclist' + acclist);
        return accList;

    }
}