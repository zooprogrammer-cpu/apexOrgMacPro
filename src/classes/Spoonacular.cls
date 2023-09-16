public with sharing class Spoonacular {
  private static final String SPOONACULAR_API = 'https://api.spoonacular.com/';
  private static final String SPOONACULAR_API_KEY = 'f6e580901d8e4476a7e685663fff6b8b';
  
  @AuraEnabled
  public static String getRandomRecipe() {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
        SPOONACULAR_API + 'recipes/random?apiKey=' + SPOONACULAR_API_KEY
    );
    request.setMethod('GET');
    HttpResponse response = http.send(request);
    // If the request is successful, parse the JSON response.
    System.debug('response code: ' + response.getStatusCode());
    if (response.getStatusCode() == 200) {
      //System.debug('response' + response.getBody());
      return response.getBody();
    }
    return '';
  }

  @AuraEnabled
  public static String getRecipe(String recipeId) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
        SPOONACULAR_API + 'recipes/' + recipeId +'/information?apiKey=' + SPOONACULAR_API_KEY
    );
    request.setMethod('GET');
    HttpResponse response = http.send(request);
    // If the request is successful, parse the JSON response.
    System.debug('response code: ' + response.getStatusCode());
    if (response.getStatusCode() == 200) {
      System.debug('response' + response.getBody());
      return response.getBody();
    }
    return '';
  }

  @AuraEnabled
  public static String getRecipeByIngredient(String ingredients) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(
        SPOONACULAR_API + 'recipes/findByIngredients?apiKey='+ SPOONACULAR_API_KEY + '&ingredients=' + ingredients);
    request.setMethod('GET');
    HttpResponse response = http.send(request);
    // If the request is successful, parse the JSON response.
    System.debug('response code: ' + response.getStatusCode());
    if (response.getStatusCode() == 200) {
      //System.debug('response' + response.getBody());
      return response.getBody();
    }
    return '';
  }
}