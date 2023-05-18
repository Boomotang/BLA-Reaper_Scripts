-- Removes matches between tbNames & tbNamesRemovse from tbFinalNames


tbNames = {"V1", "AXES", "AC", "KEYS", "PERC", "KIT"}
tbNamesRemove = {"AXES", "KEYS"}
tbFinalNames = {"V1", "AXES", "AC", "KEYS", "PERC", "KIT"}




for i=#tbNames, 1, -1 do
  for j=1, #tbNamesRemove do
    if tbNames[i] == tbNamesRemove[j] then
      table.remove(tbFinalNames, i)
      break
    end
  end
end
