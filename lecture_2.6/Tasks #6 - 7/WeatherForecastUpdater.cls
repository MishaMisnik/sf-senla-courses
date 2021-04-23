public class WeatherForecastUpdater {
	
    @Future
    public static void updateForecasts() {
        WeatherForecastService.weatherUpdate();
    }
    
    public static void insertForecasts() {
        WeatherForecastService.weatherInsert();
    }
}