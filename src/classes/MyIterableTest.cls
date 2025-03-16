/**
 * Created by ashba on 1/1/2025.
 */

@IsTest
private class MyIterableTest {
    @IsTest
    static void testIterableForLoop() {
        List<String> strings = new List<String>{'Hello','World'};
        MyIterable iter = new MyIterable(strings);

        for (String str : iter) {
            System.debug(str);
        }
    }
}