MeasureTime = 0
RealTime = 0
DeltaTime = 0
ElapsedTime = 0

function Initialize()
	MeasureTime = SKIN:GetMeasure(SELF:GetOption('TimeMeasure', 'MeasureTime'))
	DeltaFilePath = SKIN:GetMeasure(SELF:GetOption('DeltaFilePath'))
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

function GetDelta()
    local filePath = os.getenv("NotionTimeTrackerDelta")
    SKIN:Bang("!Log", filePath)

    if filePath then
        local file = io.open(filePath, "r")

        if file then
            local content = file:read("*a")

            file:close()

            return Iso8601ToWindowsTimestamp_7(content)
        else
            SKIN:Bang("!Log", "Can open file")
            return 0
        end
    else
        SKIN:Bang("!Log", "Can open file")
        return 0
    end
end

function Iso8601ToWindowsTimestamp_7(iso8601)
  local year, month, day, hour, min, sec = iso8601:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)Z")
  local timestamp = os.time{year=year, month=month, day=day, hour=hour, min=min, sec=sec}
  return timestamp + 11644473600 + 25200 * 2
end

function Start()
  SKIN:Bang("!Log", MeasureTime:GetValue())
  DeltaTime = GetDelta()
  if (DeltaTime ~= 0) then
    SKIN:Bang("!EnableMeasure", "MeasureStopwatchScript")
    SKIN:Bang("!UpdateMeter", "MeterStopwatchMainDisplay")
  end
end

function Reset()
  SKIN:Bang("!DisableMeasure", "MeasureStopwatchScript")
  SKIN:Bang("!UpdateMeter", "MeterStopwatchMainDisplay")

  MeasureTime = 0
  RealTime = 0
  DeltaTime = 0
  ElapsedTime = 0
end