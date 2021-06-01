public class FlightWorkSchedule implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        FlightCleanerBatch flightBatch = new FlightCleanerBatch();
		Database.executebatch(flightBatch);
    }
}