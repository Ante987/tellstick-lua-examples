-- Turns on set of light and turn off after set time

-- Define your device and settings here:
local trigger = "sw Bel Sovrum"		-- Name of the trigger
-- Optional
local trigger2 = "ms Sovrum"		-- Name of trigger
local trigger3 = "ms Entre"			-- Name of trigger
-- Condition to running
local condition = "vd Lights Out"	-- Name of condition device
-- Devices to turn on, DIM or ON/OFF
-- If device is dimmable then it will dim to level specified else it turn on.
local device1 = "sw Bed Blue"		-- Name of device
-- Optional
local device2 = "sw Trapp Blue"		-- Name of device
local device3 = "sw Bel KB"			-- Name of device
-- Time to turn off
local delay_minutes = 5				-- Delay in minutes
local delay_seconds = 0				-- Delay in seconds
-- Dim level if possible
local dim_level = 7					-- Dim level in %

------ Do not change below ------
local deviceManager = require "telldus.DeviceManager"
local dev_trigg = deviceManager:findByName(trigger)
local dev_trigg2 = deviceManager:findByName(trigger2)
local dev_trigg3 = deviceManager:findByName(trigger3)
local dev_cond = deviceManager:findByName(condition)
local dev_device1 = deviceManager:findByName(device1)
local dev_device2 = deviceManager:findByName(device2)
local dev_device3 = deviceManager:findByName(device3)
local dev_dim_level = dim_level * 2.55
local running = false
local debug = true					-- Print debug data to console

function onDeviceStateChanged(device, state, stateValue)
	if device:state() ~= 1 then
		return
	end
	if dev_cond:state() ~= 1 then
		if debug == true then
			print("Device: %s off", dev_cond:name())
		end
		return
	end
	if running == true then
		return
	end
 
	if device:name() == trigger then
		if debug == true then
			print("Device: %s", device:name())
		end
	elseif device:name() == trigger2 then
		if debug == true then
			print("Device: %s", device:name())
		end
	elseif device:name() == trigger3 then
		if debug == true then
			print("Device: %s", device:name())
		end
	else
		if debug == true then
			print("Device: %s", device:name())
			print("Abort")
		end
		return
	end
	if (device:state() == 1) then
		running = true
		if (dev_device1:methods() == 19) then
			dev_device1:command("dim", dev_dim_level)
			if debug == true then
				print("Setting %s to dimlevel %s%%", dev_device1:name(), dim_level)
			end
		else
			dev_device1:command("turnon", nil)
			if debug == true then
				print("Turning on: %s", dev_device1:name())
			end
		end
		if (dev_device2:methods() == 19) then
			dev_device2:command("dim", dev_dim_level)
			if debug == true then
				print("Setting %s to dimlevel %s%%", dev_device2:name(), dim_level)
			end
		else
			dev_device2:command("turnon", nil)
			if debug == true then
				print("Turning on: %s", dev_device2:name())
			end
		end
		if (dev_device3:methods() == 19) then
			dev_device3:command("dim", dev_dim_level)
			if debug == true then
				print("Setting %s to dimlevel %s%%", dev_device3:name(), dim_level)
			end
		else
			dev_device3:command("turnon", nil)
			if debug == true then
				print("Turning on: %s", dev_device3:name())
			end
		end
		print("Timer started")
		sleep(delay_minutes*60000+delay_seconds*1000)
		dev_device1:command("turnoff", nil)
		dev_device2:command("turnoff", nil)
		dev_device3:command("turnoff", nil)
		device:command("turnoff", nil, "Timer")
		print("Turning off")
	end
	running = false
end