public with sharing class AnonymousPOC {
    public static void call() {
        List<Account> accList = [SELECT  Id, Name FROM Account LIMIT 10];
        System.debug(':: ' + accList);
    }
}