public class NumberUtility {
    
    public static List<Integer> getPrimeNumbers(Integer endNumber) {
        if (endNumber <= 0 ) return new List<Integer> ();
        
        List<Integer> primeNumbers =  new List<Integer> (); 
        
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
    
    public static List<Integer> getFibonacciNumbers(Integer endNumber) {
        if (endNumber <= 0) return new List<Integer> (); 
        
        List<Integer> fibonacciNumbers =  new List<Integer>{1, 1};
        Integer indexKey = 2;
        
        while (fibonacciNumbers[fibonacciNumbers.size() - 1] < endNumber) {
            Integer fbNumber = fibonacciNumbers[indexKey - 2] + fibonacciNumbers[indexKey - 1];
            
            if (fbNumber < endNumber) {
                fibonacciNumbers.add(fbNumber);
                indexKey++;
            } else {
                return fibonacciNumbers;
            }
        }
        
        return fibonacciNumbers;
    }
    
    public static Boolean isPolindrom(Long numberToCheck) {
        if (numberToCheck == null) return false;
        
        String text = numberToCheck.format();
        
        return (text == text.reverse());
    }
}