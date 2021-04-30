public class WeatherForecastUpdater {
	
    @future(callout=true)
    public static void updateForecasts() {
        WeatherForecastService.weatherUpdate();
    }
}