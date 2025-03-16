/**
 * Created by ashbas on 2/13/25.
 */

public with sharing class StringCollectionParser {

    @InvocableMethod(label='Convert String to List')
    public static List<List<String>> convertStringToList(List<String> inputParamStrings)
    {
        List<List<String>> resultList = new List<List<String>>();

        for(String inputParamString : inputParamStrings)
        {
            if (String.isBlank(inputParamString)) continue;

            List<String> innerResultList = new List<String>();
            for (String str : inputParamString.split(','))
            {
                if (String.isBlank(str)) continue;
                innerResultList.add(str.trim());
            }
            resultList.add(new List<String>(innerResultList));
        }

        return resultList;
    }
}