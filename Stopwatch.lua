MeasureTime = 0
RealTime = 0
DeltaTime = 0
ElapsedTime = 0
Paused = 0

function Initialize()
	MeasureTime = SKIN:GetMeasure(SELF:GetOption('TimeMeasure', 'MeasureTime'))
end

function Update()
	RealTime = MeasureTime:GetValue()
	if Paused == 1 then DeltaTime = RealTime - ElapsedTime
		else ElapsedTime = (RealTime - DeltaTime) end
end

function GetTime() return FormatTimeString(ElapsedTime) end

function FormatTimeString(time)
	local hours = tostring(math.floor((time / 3600) % 24)):gsub('(.+)', '0%1'):gsub('^%d(%d%d)$', '%1')
	local minutes = tostring(math.floor((time / 60) % 60)):gsub('(.+)', '0%1'):gsub('^%d(%d%d)$', '%1')
	local seconds = tostring(math.floor(time % 60)):gsub('(.+)', '0%1'):gsub('^%d(%d%d)$', '%1')
	return hours .. ':' .. minutes .. ':' .. seconds
end

function Start()
  DeltaTime = MeasureTime:GetValue()
  SKIN:Bang("!EnableMeasure", "MeasureStopwatchScript")
  SKIN:Bang("!UpdateMeter", "MeterStopwatchMainDisplay")
end

function Pause()
  Paused = 1
  SKIN:Bang("!UpdateMeter", "MeterStopwatchMainDisplay")
end

function Resume()
  Paused = 0
  SKIN:Bang("!UpdateMeter", "MeterStopwatchMainDisplay")
end

function Reset()
  SKIN:Bang("!EnableMeasure", "MeasureStopwatchScript")
  SKIN:Bang("!DisableMeasure", "MeterStopwatchMainDisplay")

  MeasureTime = 0
  RealTime = 0
  DeltaTime = 0
  ElapsedTime = 0
  Paused = 0
end