--------------------==========--------------------
----------<<<<<<<<<< MCP Solo >>>>>>>>>>----------
--------------------==========--------------------

---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42254          --  << COMMAND ID

Name1 = " KIT  "
Name2 = "KICK"
Name3 = "K%-SUB"
Name4 = "K%-OUT"
Name5 = "K%-IN"
Name6 = "SAMP"
Name7 = "SNARE"
Name8 = "S%-TOP"
Name9 = "S%-BOT"
Name10 = "SAMP"
Name11 = "  OH  "
Name12 = "TOMS"
Name13 = "  RT  "
Name14 = "FT%-1"
Name15 = "FT%-2"
Name16 = "PFX"
Name17 = "RVB"
Name18 = "%(KIT%-MCP%)"


tbTracks = {}       -- MediaTracks
tbNames = {}        -- Names of MediaTracks
tbNewTracks = {}    -- new selection of MediaTracks from specified Names


--------------------------------------------------------------------------


reaper.Main_OnCommand(Group1, 0)  -- select group
reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELCHILDREN"), 0)

trCount = reaper.CountSelectedTracks(0)

-- put selected tracks into TABLE: tbTracks
for i=0, trCount do
  selTrack = reaper.GetSelectedTrack(0, i)
  table.insert(tbTracks, selTrack)
end

-- get track names and put them in new TABLE: tbNames
for i=1, #tbTracks do
  _, selName = reaper.GetTrackName(tbTracks[i])
  table.insert(tbNames, selName)
end

-- check names and specify ones to put from the TABLE:tbTracks into TABLE:tbNewTracks
for i=1, #tbNames do
  if
    string.find(tbNames[i], Name1) or
    string.find(tbNames[i], Name2) or
    string.find(tbNames[i], Name3) or
    string.find(tbNames[i], Name4) or
    string.find(tbNames[i], Name5) or
    string.find(tbNames[i], Name6) or
    string.find(tbNames[i], Name7) or
    string.find(tbNames[i], Name8) or
    string.find(tbNames[i], Name9) or
    string.find(tbNames[i], Name10) or
    string.find(tbNames[i], Name11) or
    string.find(tbNames[i], Name12) or
    string.find(tbNames[i], Name13) or
    string.find(tbNames[i], Name14) or
    string.find(tbNames[i], Name15) or
    string.find(tbNames[i], Name16) or
    string.find(tbNames[i], Name17) or
    string.find(tbNames[i], Name18) then
      table.insert(tbNewTracks, tbTracks[i])
  end
end

reaper.Main_OnCommand(40297, 0)  -- unselect all tracks





-- select all tracks from TABLE: tbNewTracks
for i=1, #tbNewTracks do
  reaper.SetTrackSelected(tbNewTracks[i], true)
end


reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWSTL_SHOWMCPEX"), 0)


-- Scroll mixer to first track.
reaper.Main_OnCommand(Group1, 0)  -- select group
reaper.Main_OnCommand(reaper.NamedCommandLookup("_XENAKIOS_SELNEXTTRACK"), 0)
reaper.Main_OnCommand(reaper.NamedCommandLookup("_XENAKIOS_SELNEXTTRACK"), 0)

scrollMixer = reaper.NamedCommandLookup("_RS3362313dca57362b5f65ccc16fa19c12a2d6487e")
reaper.Main_OnCommand(scrollMixer,0)
