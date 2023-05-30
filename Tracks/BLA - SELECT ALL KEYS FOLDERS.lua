---------------------------------------
----- SET THE FOLLOWING VARIABLES -----
---------------------------------------
Group1 = 42262          --  << COMMAND ID
Group2 = 42261          --  << COMMAND ID
Group3 = 42260          --  << COMMAND ID


tbTracks = {}     -- MediaTracks


function addTracks(group)
  reaper.Main_OnCommand(group, 0)  -- select group

  trCount = reaper.CountSelectedTracks(0)

  -- put selected tracks into TABLE: tbTracks
  for i=0, trCount do
    selTrack = reaper.GetSelectedTrack(0, i)
    table.insert(tbTracks, selTrack)
  end

  reaper.Main_OnCommand(40297, 0)  -- unselect all tracks
end

------------------------------------------------------------

addTracks(Group1)

addTracks(Group2)

addTracks(Group3)


-- select all tracks from TABLE: tbTracks
for i=1, #tbTracks do
  reaper.SetTrackSelected(tbTracks[i], true)
end
