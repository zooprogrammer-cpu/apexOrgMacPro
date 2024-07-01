public class Contract {

    Integer activatedYear;

    public Contract(Integer activatedYear){
        this.activatedYear = activatedYear;
    }

    public Integer calculateContractAge() {
        Integer currentYear = 2023;
        Integer result = currentYear - this.activatedYear;
        return result;
    }

}