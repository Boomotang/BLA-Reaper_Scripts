


-- USER SETUP ----------------------

Track1 = "TRACK_NAME"
Group1 = 11111
Group2 = 22222

------------------------- USER SETUP


-- SETTING INITIAL TOGGLE STATE
toggleA = false


-- Scroll mixer to selected track.
function mixerScroll()
  selTrack = reaper.GetSelectedTrack(0,0)
  reaper.SetMixerScroll(selTrack)
end

----------------------------------------------

-- END SCRIPT IF NO TRACKS SELECTED
trackCount = reaper.CountSelectedTracks(0)
if trackCount == 0 then return end


-- Get Track Name of selected track.
_, trackName = reaper.GetTrackName(reaper.GetSelectedTrack(0,0), "")


-- SET TOGGLE STATE AFTER CHECKING SELECTED TRACK NAME
if trackName == Track1   then   toggleA = true   end


-------------- SCROLLING ACTIONS -------------

------------ TRACK 1 NOT SELECTED ------------

if toggleA == false then
  reaper.Main_OnCommand(Group1,0)  -- select Group 1
  
  trackCount = reaper.CountSelectedTracks(0)
  if trackCount >= 1 then  -- Don't scroll if no tracks were selected.
    mixerScroll()
    else
      reaper.Main_OnCommand(Group2,0)  -- select Group 2
      
      trackCount = reaper.CountSelectedTracks(0)
      if trackCount >= 1 then  -- Don't scroll if no tracks were selected.
        mixerSCroll()
      end
  end
end


------------- TRACK 1 SELECTED -------------

if toggleA == true then
  reaper.Main_OnCommand(Group2,0) -- select Group 2
  
  trackCount = reaper.CountSelectedTracks(0)
  if trackCount >= 1 then  -- Don't scroll if no tracks were selected.
    mixerScroll()
    else
      reaper.Main_OnCommand(Group1,0)  -- select Group 1
  end
end
