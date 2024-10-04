-- Taken from https://forum.openwrt.org/t/periodic-temp-readings-from-collectd-to-log-files/111567/22?u=dezeroku
-- and modified so the exported metrics match the "Node Exporter Full" grafana dashboard requirements
local function scrape()
  thermal_metric =  metric("node_thermal_zone_temp", "gauge" )
  thermal_metric_hwmon =  metric("node_hwmon_temp_celsius", "gauge" )

  local fd = io.popen("find /sys/class/thermal/*/ -name temp")
  local lines = fd:read("*all")
  fd:close()
  -- Report thermal per zone
  for line in lines:gmatch("([^\r\n]*)[\r\n]") do
    if line then
      local zone = string.gsub(string.match(line, "zone%d+"), "zone", "")
      local temp = string.gsub(get_contents(line), "n", "") / 1000
      local labels = { zone = zone }
      thermal_metric(labels, tostring(temp))
      thermal_metric_hwmon(labels, tostring(temp))
    end
  end
end

return { scrape = scrape }
