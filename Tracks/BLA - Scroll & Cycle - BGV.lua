--------------------============================--------------------
----------<<<<<<<<<< Scroll & Cycle to 2 Tracks >>>>>>>>>>----------
--------------------============================--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42264          --  << COMMAND ID

-- Get the command_id-number Reaper uses internally for Scroll Mixer action.
scrollMixer = reaper.NamedCommandLookup("_RS3362313dca57362b5f65ccc16fa19c12a2d6487e") -- <<<<<<<<<<<<<<< CHECK


reaper.Main_OnCommand(Group1,0) -- select Group 1
  
reaper.Main_OnCommand(scrollMixer,0)
reaper.Main_OnCommand(40913, 0)       -- vertical scroll in TCP
