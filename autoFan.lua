-- Script to turn on a fan if the humidity difference between two sensors is more than the trigger value

HUMIDITY = 2							-- Sensor type flag for humidity
SCALE_HUMIDITY_PERCENT = 0				-- Sensor scale flag for humidity percent

-- Reference sensor
local sensor_ref = "te Hall" 			-- Name of referens sensor

-- Must have value 
local sensor_trigg = "te Badrum Uppe" 	-- Name of trigger sensor nr 1 (Required)
local relay = "fa Badrum Uppe" 			-- Name of switch nr 1 (Required)

-- Optional
-- Add XXX to shutdown function fan 2
local sensor_trigg2 = "te Badrum Nere"	-- Name of trigger sensor nr 2 (Optional)
local relay2 = "fa Badrum Nere"			-- Name of switch nr 2 (Optional)

-- Settings
local trigger = 15        				-- Trigger value
local adjust1 = 0                       -- For local differens
local adjust2 = 10                      -- Adjust differense between sensors 
local debug = false						-- Print debug data to console
local verbose = false					-- Print even more debug data
local sensor_trigg_value = 0
local sensor_trigg2_value = 0
local sensor_ref_value = 0
local relay_status = 0
local relay2_status = 0

local deviceManager = require "telldus.DeviceManager"
local dev_sensor_trigg = deviceManager:findByName(sensor_trigg)
local dev_sensor_trigg2 = deviceManager:findByName(sensor_trigg2)
local dev_sensor_ref = deviceManager:findByName(sensor_ref)
local dev_fan_relay = deviceManager:findByName(relay)
local dev_fan_relay2 = deviceManager:findByName(relay2)

function onInit()
	print("Waiting for sensor values...")
end

function onSensorValueUpdated(device, valueType, value, scale)
	-- Sensor and Fan 1
	if dev_sensor_trigg == nil or dev_fan_relay == nil then
		if debug == true then
			print("Function 1 not Active...")
		end
	else
		if device:id() == dev_sensor_trigg:id() and valueType == HUMIDITY and scale == SCALE_HUMIDITY_PERCENT or device:id() == dev_sensor_ref:id() and valueType == HUMIDITY and scale == SCALE_HUMIDITY_PERCENT then  -- filter out sensors
			if verbose == true then
				print("Verbose debug data:")
				print("Device id: %s", device:id())
				print("Sensor type: %s", valueType)
				print("Sensor scale: %s", scale)
			end		
			local sensor_trigg_value = dev_sensor_trigg:sensorValue(HUMIDITY, SCALE_HUMIDITY_PERCENT)  -- get sensor values
			local sensor_ref_value = dev_sensor_ref:sensorValue(HUMIDITY, SCALE_HUMIDITY_PERCENT)
			Diff = sensor_trigg_value - sensor_ref_value - adjust1 -- calculate the diff
			if verbose == true then
				print("sensor_trigg_value: %s", sensor_trigg_value)
				print("sensor_ref_value: %s", sensor_ref_value)
			end
			if debug == true then
				print("Diff: %s", Diff)
			end
			if Diff >= trigger then
				if relay_status == 0 then
					dev_fan_relay:command("turnon", nil, "Fukt_trigger")  -- turn on switch if diff > trigger
					relay_status = 1
					if debug == true then
						print("Turning on device: %s", relay)
					end
				end
			else
				if relay_status == 1 then
					dev_fan_relay:command("turnoff", nil, "Fukt_trigger")  -- turn off switch if diff < trigger
					relay_status = 0
					if debug == true then
						print("Turning off device: %s", relay)	
					end
				end
			end
		end
	end
	-- Sensor and fan 2
	if dev_sensor_trigg2 == nil or dev_fan_relay2 == nil then
		if debug == true then
			print("Function 2 not Active...")
		end
	else
		if device:id() == dev_sensor_trigg2:id() and valueType == HUMIDITY and scale == SCALE_HUMIDITY_PERCENT or device:id() == dev_sensor_ref:id() and valueType == HUMIDITY and scale == SCALE_HUMIDITY_PERCENT then  -- filter out sensors
			if verbose == true then
				print("Verbose debug data:")
				print("Device id: %s", device:id())
				print("Sensor type: %s", valueType)
				print("Sensor scale: %s", scale)
			end		
			local sensor_trigg2_value = dev_sensor_trigg2:sensorValue(HUMIDITY, SCALE_HUMIDITY_PERCENT)  -- get sensor values
			local sensor_ref_value = dev_sensor_ref:sensorValue(HUMIDITY, SCALE_HUMIDITY_PERCENT)
			Diff = sensor_trigg2_value - sensor_ref_value - adjust2   -- calculate the diff
			if verbose == true then
				print("sensor_trigg2_value: %s", sensor_trigg2_value)
				print("sensor_ref_value: %s", sensor_ref_value)
			end
			if debug == true then
				print("Diff: %s", Diff)
			end
			if Diff >= trigger then
				if relay2_status == 0 then
					dev_fan_relay2:command("turnon", nil, "Fukt_trigger2")  -- turn on switch if diff > trigger
					relay2_status = 1
					if debug == true then
						print("Turning on device: %s", relay2)
					end
				end
			else
				if relay2_status == 1 then
					dev_fan_relay2:command("turnoff", nil, "Fukt_trigger2")  -- turn off switch if diff < trigger
					relay2_status = 0
					if debug == true then
						print("Turning off device: %s", relay2)	
					end
				end
			end
			if verbose == true or debug == true then
				print("--")
			end
		end
	end
end