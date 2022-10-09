Config = {}

Config.command = "sperrzone"        -- Command used to set the exclusion zone
Config.deletecommand = "dsperrzone" -- Command used to delete the Zone


Config.whitelistedjobs = {          -- Jobs that can set the Zone
    "police"
}


Config.announce = function(msg)     -- The notify System used
    ESX.ShowNotification(msg)
end

Config.maxradius = 500              -- The Maximum Radius someone can set the zone

Config.sperrzonentype = 1           --1 = blinking Zone, 2 = Static zone, if 3 or higher you will get an error