public class WeatherForecastSchedule implements Schedulable{
    
    public void execute(SchedulableContext sc) {
        WeatherForecastUpdater.updateForecasts();
    }
}