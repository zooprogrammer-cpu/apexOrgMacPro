@RestResource(UrlMapping='/showAccountsDetails')
global class MulesoftAPI {
    @HttpGet
    global static List<Account> getAccount() {
        List<Account> lst;
        try {
            lst = [SELECT Name, Phone FROM Account];
            return lst;
        }
        catch(Exception ex) {
            System.debug('Error' + ex.getMessage());
        }
        return lst;
    }
}