--[[
  *         Name:
  *  Description:
  * Instructions:
  *
  *       Author: Boomotang
  *        Links:
  *   Repository:
  * 
  *      Version: v0.1.0
--]]

--[[
  *    Changelog:
  * v0.1.0 (2023-00-00)
--]]



-- USER CONFIG AREA -------------------------------------------------------------------------------

console = true  -- display debug messages in the console

--------------------------------------------------------------------------- END OF USER CONFIG AREA



-- FUNCTIONS --------------------------------------------------------------------------------------

-- Display a message in the console for debugging
function Msg(value)
  if console then
    reaper.ShowConsoleMsg(tostring(value) .. "\n")
  end
end


-- MAIN FUNCTION
function main()

end

---------------------------------------------------------------------------------- END OF FUNCTIONS



-- INIT -------------------------------------------------------------------------------------------

