/**
 * Created by ashbas on 2/13/25.
 */
@isTest
public with sharing class StringCollectionParserTest {

    @isTest
    public static void testConvertStringToList() {
        String str = '1,2,3';
        List<List<String>> res = StringCollectionParser.convertStringToList(new List<String>{str});
        System.assertEquals(res.get(0), new list<String>{'1','2','3'});
    }
}