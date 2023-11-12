-- ----------------------------------------
-- Stopwatch.lua
-- v1.0.0
-- raiguard
-- ----------------------------------------

measureTime = 0
realTime = 0
deltaTime = 0
elapsedTime = 0

lapDeltaTime = 0
lapTime = 0
lapCount = 0
lapScroll = 0
laps = {}
lapListHeight = 0

paused = 0

debug = false

function Initialize()

	measureTime = SKIN:GetMeasure(SELF:GetOption('TimeMeasure', 'MeasureTime'))
	lapListHeight = tonumber(SELF:GetOption('LapListHeight', 5))
	showHours = tonumber(SELF:GetOption('ShowHours', 1))
	Reset()

end

function Update() --> Updates the stopwatch time and lap time ten times a second

	realTime = measureTime:GetValue()
	if paused == 1 then deltaTime = realTime - elapsedTime
		else elapsedTime = (realTime - deltaTime) end

end

function Reset() --> Resets all stopwatch statistics to their starting point

	realTime = 0
	deltaTime = 0
	elapsedTime = 0

	lapDeltaTime = 0
	lapTime = 0
	lapCount = 0
	lapScroll = 0
	laps = {}

	paused = 0

end

function GetTime() return FormatTimeString(elapsedTime) end --> Returns the current stopwatch time. Usage: Text=[&MeasureStopwatchScript:GetTime()]

function GetLapTime() return FormatTimeString(elapsedTime - lapDeltaTime) end --> Returns the current stopwatch lap time. Usage: Text=[&MeasureStopwatchScript:GetLapTime()]

function GetLap(lap, value) --> Returns the lap number, lap time, or stopwatch time for a specific lap.

	if lapCount <= lap - 1 then return '-'
	elseif value then return laps[lapScroll - (lap - 1)][value]
		else return lapScroll - (lap - 1) end

	-- USAGE:
	-- Text=[&MeasureStopwatchScript:GetLap(1)] --> Returns the lap number of the highest lap on the list
	-- Text=[&MeasureStopwatchScript:GetLap(1, 'lap')] --> Returns the lap's lap time
	-- Text=[&MeasureStopwatchScript:GetLap(1, 'total')] --> Returns the total stopwatch time when that lap was made

end

function Lap() --> Takes the current stopwatch time and creates a new lap from it

	if lapScroll == lapCount then lapScroll = lapScroll + 1 end
	lapCount = lapCount + 1
	table.insert(laps, lapCount, { lap = GetLapTime(), total = GetTime() })
	lapDeltaTime = elapsedTime
	LogHelper('Lap ' .. lapCount .. ' = ' .. laps[lapCount]['total'], 'Debug')
	SKIN:Bang('!UpdateMeterGroup', 'LapMeters')
	SKIN:Bang('!Redraw')

end

function LapScrollUp() --> Scrolls the lap list up. Will automatically stop if the top of the list is reached.

	if lapScroll < lapCount then
		lapScroll = lapScroll + 1
		SKIN:Bang('!UpdateMeterGroup', 'LapMeters')
		SKIN:Bang('!Redraw')
	end
end

function LapScrollDown() --> Scrolls the lap list down. Will automatically stop if the bottom of the list is reached.

	if lapScroll > lapListHeight then
		lapScroll = lapScroll - 1
		SKIN:Bang('!UpdateMeterGroup', 'LapMeters')
		SKIN:Bang('!Redraw')
	end
end

function FormatTimeString(time) --> Converts a raw timestamp value into a human-readable format.

	local hours = tostring(math.floor((time / 3600) % 24)):gsub('(.+)', '0%1'):gsub('^%d(%d%d)$', '%1')
	local minutes = tostring(math.floor((time / 60) % 60)):gsub('(.+)', '0%1'):gsub('^%d(%d%d)$', '%1')
	local seconds = tostring(math.floor(time % 60)):gsub('(.+)', '0%1'):gsub('^%d(%d%d)$', '%1')
	local tenths = round((time * 10) % 10)
	if tenths == 10 then tenths = 0 end

	if showHours == 1 then return hours .. ':' .. minutes .. ':' .. seconds .. '.' .. tenths
		else return minutes .. ':' .. seconds .. '.' .. tenths end

end

function round(x) --> Rounds...
  if x%2 ~= 0.5 then
    return math.floor(x+0.5)
  end
  return x-0.5
end

-- function to make logging messages less cluttered
function LogHelper(message, type)

  if type == nil then type = 'Debug' end

  if debug == true then
    SKIN:Bang("!Log", message, type)
  elseif type ~= 'Debug' then
  	SKIN:Bang("!Log", message, type)
	end

end