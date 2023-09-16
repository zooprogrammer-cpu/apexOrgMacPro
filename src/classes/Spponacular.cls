public with sharing class Spponacular {
    private static final String SPOONACULAR_API = 'https://api.spoonacular.com/';
    private static final String SPOONACULAR_API_KEY = 'f6e580901d8e4476a7e685663fff6b8b';

    public static void getRandomRecipe() {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
        SPOONACULAR_API + 'recipes/random?apiKey' + SPOONACULAR_API_KEY
    );
    request.setMethod('GET');
    HttpResponse response = http.send(request);
    // If the request is successful, parse the JSON response.
    System.debug('response code: ' + response.getStatusCode());
    if (response.getStatusCode() == 200) {
      System.debug('response' + response.getBody());
    }
  }
}