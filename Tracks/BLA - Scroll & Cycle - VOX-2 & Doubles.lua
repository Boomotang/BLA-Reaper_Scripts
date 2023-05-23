--------------------============================--------------------
----------<<<<<<<<<< Scroll & Cycle to 2 Tracks >>>>>>>>>>----------
--------------------============================--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Track1 = "L-VOX2"
Group1 = 42266          --  << COMMAND ID
Group2 = 42265          --  << COMMAND ID


-- Get info of this action.
is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()

-- Get the command_id-number Reaper uses internally for Scroll Mixer action.
scrollMixer = reaper.NamedCommandLookup("_RS3362313dca57362b5f65ccc16fa19c12a2d6487e") -- <<<<<<<<<<<<<<< CHECK


-- Setting initial toggle states.
toggleA = false


-- Don't GetTrackName if no tracks are selected.
trackCount = reaper.CountSelectedTracks(0)

-- Get Track Name of selected track.
if trackCount >= 1 then
  trackNameCheck, trackName = reaper.GetTrackName(reaper.GetSelectedTrack(0,0), "")
end

---------------------------------------------------------------------
----- Setting toggle states after checking selected Track Name ------

if trackName == Track1   then   toggleA = true   end

---------------------------------------------------------
------------------- SCROLLING ACTIONS -------------------

------------ TRACK 1 NOT SELECTED ------------

if toggleA == false then
  reaper.Main_OnCommand(Group1,0) -- select Group 1
  
  trackCount = reaper.CountSelectedTracks(0)
  if trackCount >= 1 then                  -- Don't scroll if no tracks were selected.
    reaper.Main_OnCommand(scrollMixer,0)
    else
      reaper.Main_OnCommand(Group2,0) -- select Group 2
      
      trackCount = reaper.CountSelectedTracks(0)
      if trackCount >= 1 then                -- Don't scroll if no tracks were selected.
        reaper.Main_OnCommand(scrollMixer,0)
      end
  end
end


------------- TRACK 1 SELECTED -------------

if toggleA == true then
  reaper.Main_OnCommand(Group2,0) -- select Group 2
  
  trackCount = reaper.CountSelectedTracks(0)
  if trackCount >= 1 then                 -- Don't scroll if no tracks were selected.
    reaper.Main_OnCommand(scrollMixer,0)
    else
      reaper.Main_OnCommand(Group1,0) -- select Group 1
  end
end
