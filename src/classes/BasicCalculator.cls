public class BasicCalculator {
    public static Integer sum(Integer a, Integer b) {
        return a+b;
    }
    
    public static Integer difference(Integer a, Integer b) {
        if (a>b)
            return a-b;
        else
            return b-a;
    }
}