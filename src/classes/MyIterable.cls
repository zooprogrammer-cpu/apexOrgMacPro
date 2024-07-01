public with sharing class MyIterable {
    public Iterator<String> iterator() {
        return new Set<String> {'Hello', 'World'}.iterator();
    }
}