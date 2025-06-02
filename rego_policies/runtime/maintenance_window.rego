package aap_policy_examples

# Define maintenance window in UTC
maintenance_start_hour := 18 # 15:00 UTC (5 PM EST)

maintenance_end_hour := 20 # 17:00 UTC (9 AM EST)

# Extract the job creation timestamp (which is in UTC)
created_clock := time.clock(time.parse_rfc3339_ns(input.created)) # returns [hour, minute, second]

created_hour_utc := created_clock[0]

# Check if job was created within the maintenance window (UTC)
is_maintenance_time if {
	maintenance_start_hour <= maintenance_end_hour
	created_hour_utc >= maintenance_start_hour
	created_hour_utc <= maintenance_end_hour
}

is_maintenance_time if {
	maintenance_start_hour > maintenance_end_hour
	created_hour_utc >= maintenance_start_hour
} else if {
	maintenance_start_hour > maintenance_end_hour
	created_hour_utc <= maintenance_end_hour
}

default maintenance_window := {
	"allowed": true,
	"violations": [],
}

maintenance_window := {
	"allowed": false,
	"violations": ["No job execution allowed outside of maintenance window"],
} if {
	not is_maintenance_time
}