FUNCTIONS


GET MARKER/REGION INFO
----------------------------------------------------------------------------------------------------------------------------------

integer markeridx, integer regionidx = reaper.GetLastMarkerAndCurRegion(ReaProject proj, number time)

Get the last project marker before time, and/or the project region that includes time. markeridx and regionidx are returned not necessarily as the displayed marker/region index, but as the index that can be passed to EnumProjectMarkers. Either or both of markeridx and regionidx may be NULL. See EnumProjectMarkers.

----------------------------------------------------------------------------------------------------------------------------------

integer retval, boolean isrgn, number pos, number rgnend, string name, integer markrgnindexnumber = reaper.EnumProjectMarkers(integer idx)

----------------------------------------------------------------------------------------------------------------------------------

integer retval, integer num_markers, integer num_regions = reaper.CountProjectMarkers(ReaProject proj)

num_markersOut and num_regionsOut may be NULL.

----------------------------------------------------------------------------------------------------------------------------------





GO TO MARKER/REGION/POSITION
----------------------------------------------------------------------------------------------------------------------------------

reaper.GoToMarker(ReaProject proj, integer marker_index, boolean use_timeline_order)

Go to marker. If use_timeline_order==true, marker_index 1 refers to the first marker on the timeline. If use_timeline_order==false, marker_index 1 refers to the first marker with the user-editable index of 1.

----------------------------------------------------------------------------------------------------------------------------------

reaper.GoToRegion(ReaProject proj, integer region_index, boolean use_timeline_order)

Seek to region after current region finishes playing (smooth seek). If use_timeline_order==true, region_index 1 refers to the first region on the timeline. If use_timeline_order==false, region_index 1 refers to the first region with the user-editable index of 1.

----------------------------------------------------------------------------------------------------------------------------------

reaper.SetEditCurPos(number time, boolean moveview, boolean seekplay)

----------------------------------------------------------------------------------------------------------------------------------
