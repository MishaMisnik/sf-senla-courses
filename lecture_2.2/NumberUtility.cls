public class NumberUtility {
	
    public static List<integer> GetPrimeNumbers(Integer endNumber) {
        if (endNumber == 0) {
            return new List<integer>(); 
        }
        List<integer> primeNumbers =  new List<integer> {}; 
        
        for (Integer i = 2; i < endNumber; i++) {
            Integer check = 0;
            
            for (Integer j = 1; j < i && check < 2; j++) {
                if (math.mod(i, j) == 0) {
                    check++;
                }
            }
            
            if (check < 2) {
                primeNumbers.add(i);
            }
        }
        
        return primeNumbers;
    }
    
    public static List<integer> GetFibonacciNumbers(Integer endNumber) {
        List<integer> fibonacciNumbers =  new List<integer>{1, 2};
		if (endNumber <= 2) {
            return fibonacciNumbers; 
        }
        Integer indexKey = 2;
		
        while (fibonacciNumbers[fibonacciNumbers.size() - 1] < endNumber) {
            Integer fbNumber = fibonacciNumbers[indexKey - 2] + fibonacciNumbers[indexKey - 1];
            
            if (fbNumber < endNumber) {
                fibonacciNumbers.add(fbNumber);
                indexKey++;
            }else{
                break;
            }
        }
        
        return fibonacciNumbers;
    }
    
    public static Boolean GetChekcPolindrom(Long numberToCheck) {
        if (numberToCheck == null) {
            return false;
        }
        String elementToCheck = string.valueOf(numberToCheck);
        Boolean check = true;
        Integer numLength = elementToCheck.length();
        
        for (Integer i = 0; i < numLength; i++) {
            if (elementToCheck.charAt(i) != elementToCheck.charAt(numLength - 1 -i)) {
                check = false;
            }
        }
        
        return check;
    }
}