public class NumberUtility {
	
    public static List<integer> getPrimeNumbers(integer endNumber){
        List<integer> primeNumbers =  new List<integer>{}; 
        for(integer i = 2; i < endNumber; i++){
            integer check = 0;
            
            for(integer j = 1; j < i && check < 2; j++){
                
                if(math.mod(i, j) == 0){
                    check++;
                }
            }
            
            if(check < 2){
                primeNumbers.add(i);
            }
        }
        return primeNumbers;
    }
    
    public static List<integer> getFibonacciNumbers(integer endNumber){
        List<integer> fibonacciNumbers =  new List<integer>{1, 2};
        integer indexKey = 2;
		
        while(fibonacciNumbers[fibonacciNumbers.size() - 1] < endNumber){
            integer fbNumber = fibonacciNumbers[indexKey - 2] + fibonacciNumbers[indexKey - 1];
            
            if(fbNumber < endNumber){
                fibonacciNumbers.add(fbNumber);
                indexKey++;
            }else{
                break;
            }
        }
        
        return fibonacciNumbers;
    }
    
    public static boolean getChekcPolindrom(long numberToCheck){
        string elementToCheck = string.valueOf(numberToCheck);
        boolean check = true;
        integer numLength = elementToCheck.length();
        
        for(integer i = 0; i < numLength; i++){
            
            if(elementToCheck.charAt(i) != elementToCheck.charAt(numLength - 1 -i)){
                check = false;
            }
        }
        
        return check;
    }
}