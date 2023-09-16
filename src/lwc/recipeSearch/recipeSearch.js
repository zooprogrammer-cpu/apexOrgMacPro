import { LightningElement} from 'lwc';
import getRandomRecipe from "@salesforce/apex/Spoonacular.getRandomRecipe";
import getRecipeByIngredient from "@salesforce/apex/Spoonacular.getRecipeByIngredient";

export default class RecipeSearch extends LightningElement {
    recipes =[]; 
    searchKey = ''
    fetchRandomRecipe(){
        getRandomRecipe()
            .then((data)=>{
                this.recipes = JSON.parse(data) && JSON.parse(data).recipes ? JSON.parse(data).recipes :[];
            })
            .catch((error)=>{
                console.log('Error:', error);
            })
    }

    handleKeyChange(event) {
        this.searchKey = event.target.value;
    }

    fetchRecipesByIngredients(){
        const ingredients = this.searchKey;
        getRecipeByIngredient({ingredients})
            .then((data)=>{
                this.recipes = JSON.parse(data);
            })
            .catch((error)=>{
                console.log('Error: ', error);

            })
    }




    
}