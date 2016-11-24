public class ProcessBuilderTesting{
    
    @InvocableMethod
    public static void Init(List<Account> accRec){
        system.debug('####'+accRec);
    }
}