--------------------============================--------------------
----------<<<<<<<<<< Scroll & Cycle to 3 Tracks >>>>>>>>>>----------
--------------------============================--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
local Track1 = " KIT  "
local Track2 = " KICK "
local Group1 = 42254          --  << COMMAND ID
local Group2 = 42253          --  << COMMAND ID
local Group3 = 42239          --  << COMMAND ID


-- Get info of this action.
local is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()

-- Get the command_id-number Reaper uses internally for Scroll Mixer action.
local scrollMixer = reaper.NamedCommandLookup("_RS3362313dca57362b5f65ccc16fa19c12a2d6487e") -- <<<<<<<<<<<<<<< CHECK


-- Setting initial toggle states.
local toggleA = false
local toggleB = false


-- Don't GetTrackName if no tracks are selected.
local trackCount = reaper.CountSelectedTracks(0)

-- Get Track Name of selected track.
if trackCount >= 1 then
  TrackNameCheck, TrackName = reaper.GetTrackName(reaper.GetSelectedTrack(0,0))
end

---------------------------------------------------------------------
----- Setting toggle states after checking selected Track Name ------

if TrackName == Track1   then   toggleA = true   end

if TrackName == Track2   then   toggleB = true   end

---------------------------------------------------------
------------------- SCROLLING ACTIONS -------------------


--------------- TRACKS 1 & 2 NOT SELECTED ---------------

if toggleA == false and toggleB == false then
  reaper.Main_OnCommand(Group1,0) -- select Group 1
  
  trackCount = reaper.CountSelectedTracks(0)
  if trackCount >= 1 then                  -- Don't scroll if no tracks were selected.
    reaper.Main_OnCommand(scrollMixer,0)
    reaper.Main_OnCommand(40913, 0)
    else
    reaper.Main_OnCommand(Group2,0) -- select Group 2
    
    trackCount = reaper.CountSelectedTracks(0)
    if trackCount >= 1 then                -- Don't scroll if no tracks were selected.
      reaper.Main_OnCommand(scrollMixer,0)
      reaper.Main_OnCommand(40913, 0)
      else
      reaper.Main_OnCommand(Group3,0) -- select Group 3
      
      trackCount = reaper.CountSelectedTracks(0)
      if trackCount >= 1 then              -- Don't scroll if no tracks were selected.
        reaper.Main_OnCommand(scrollMixer,0)
        reaper.Main_OnCommand(40913, 0)
      end
    end
  end
end


--------------- TRACK 1 SELECTED ---------------

if toggleA == true then
  reaper.Main_OnCommand(Group2,0) -- select Group 2
  
  trackCount = reaper.CountSelectedTracks(0)
  if trackCount >= 1 then                 -- Don't scroll if no tracks were selected.
  reaper.Main_OnCommand(scrollMixer,0)
  reaper.Main_OnCommand(40913, 0)
  else
    reaper.Main_OnCommand(Group3,0) -- select Group 3
    
    trackCount = reaper.CountSelectedTracks(0)
    if trackCount >= 1 then               -- Don't scroll if no tracks were selected.
    reaper.Main_OnCommand(scrollMixer,0)
    reaper.Main_OnCommand(40913, 0)
    else
      reaper.Main_OnCommand(Group1,0) -- select Group 1
    end
  end
end


--------------- TRACK 2 SELECTED ---------------

if toggleB == true then
  reaper.Main_OnCommand(Group3,0) -- select Group 3
  
  trackCount = reaper.CountSelectedTracks(0)
    if trackCount >= 1 then              -- Don't scroll if no tracks were selected.
    reaper.Main_OnCommand(scrollMixer,0)
    reaper.Main_OnCommand(40913, 0)
    else
      reaper.Main_OnCommand(Group1,0) -- select Group 1
      
      trackCount = reaper.CountSelectedTracks(0)
      if trackCount >= 1 then            -- Don't scroll if no tracks were selected.
      reaper.Main_OnCommand(scrollMixer,0)
      reaper.Main_OnCommand(40913, 0)
      else
        reaper.Main_OnCommand(Group2,0) -- select Group 2
      end
    end
end
