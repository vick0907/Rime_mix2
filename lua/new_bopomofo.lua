local optional_symbols = {
  ["1"] = 0x3105,
  ["q"] = 0x3106,
  ["a"] = 0x3107,
  ["z"] = 0x3108,
  ["2"] = 0x3109,
  ["w"] = 0x310A,
  ["s"] = 0x310B,
  ["x"] = 0x310C,
  ["e"] = 0x310D,
  ["d"] = 0x310E,
  ["c"] = 0x310F,
  ["r"] = 0x3110,
  ["f"] = 0x3111,
  ["v"] = 0x3112,
  ["5"] = 0x3113,
  ["t"] = 0x3114,
  ["g"] = 0x3115,
  ["b"] = 0x3116,
  ["y"] = 0x3117,
  ["h"] = 0x3118,
  ["n"] = 0x3119,
  ["u"] = 0x3127,
  ["j"] = 0x3128,
  ["m"] = 0x3129,
  ["8"] = 0x311A,
  ["i"] = 0x311B,
  ["k"] = 0x311C,
  [","] = 0x311D,
  ["9"] = 0x311E,
  ["o"] = 0x311F,
  ["l"] = 0x3120,
  ["."] = 0x3121,
  ["0"] = 0x3122,
  ["p"] = 0x3123,
  [";"] = 0x3124,
  ["/"] = 0x3125,
  ["-"] = 0x3126
}

local function literal_tail(context, start, finish)
  local raw = context.input:sub(start + 1, finish)
  if finish ~= #context.input or #raw < 2 or raw:sub(-1) ~= " " then
    return
  end
  local initial = raw:sub(-2, -2)
  if not optional_symbols[initial]
      or (#raw > 2 and not raw:sub(-3, -3):match("[ 3467']")) then
    return
  end
  return initial, finish - 2
end

local function select_literal(context, spans, initial, start, length)
  context:pop_input(length)
  context:push_input("';" .. initial .. "'")
  spans[start] = initial
  local composition = context.composition
  local suffix = composition:back()
  if suffix and suffix:has_tag("all_bpm_suffix") then
    suffix.status = "kSelected"
    composition:push_back(Segment(#context.input, #context.input))
  end
end

local function process(key, env)
  local context = env.engine.context
  local spans = env.bopomofo_spans or {}
  env.bopomofo_spans = spans
  for start, initial in pairs(spans) do
    if context.input:sub(start + 1, start + 4) ~= "';" .. initial .. "'" then
      spans[start] = nil
    end
  end
  local key_name = key:repr()
  if key_name == "BackSpace" then
    local start = context.caret_pos - 4
    if spans[start] then
      context:pop_input(4)
      spans[start] = nil
      return 1
    end
  elseif key_name == "Escape" and next(spans) then
    context:clear()
    env.bopomofo_spans = {}
    return 1
  end
  if key_name ~= "space" then
    return 2
  end
  local selected = context:get_selected_candidate()
  if selected and selected.type == "bopomofo_literal"
      and context.caret_pos == #context.input and not context:get_option("ascii_mode") then
    local initial, start = literal_tail(context, selected.start, selected._end)
    if initial then
      select_literal(context, spans, initial, start, 2)
      return 1
    end
  end
  return 2
end

local function filter(input, env)
  local context = env.engine.context
  local segment = context.composition:back()
  local initial, start
  if segment and segment:has_tag("abc") and not context:get_option("ascii_mode")
      and context.caret_pos == #context.input then
    initial, start = literal_tail(context, segment.start, segment._end)
  end
  local offered = false
  local function offer_literal(source)
    local prefix = ""
    if start > segment.start then
      if not source or source._end ~= segment._end
          or source:spans():previous_stop(source._end) ~= start then
        return
      end
      local last_character = utf8.offset(source.text, -1)
      if not last_character then
        return
      end
      prefix = source.text:sub(1, last_character - 1)
    end
    local text = prefix .. utf8.char(optional_symbols[initial])
    local candidate = Candidate("bopomofo_literal", segment.start, segment._end, text,
      utf8.char(0x3014, 0x6CE8, 0x97F3, 0x3015))
    candidate.preedit = text
    yield(candidate)
    offered = true
  end
  for candidate in input:iter() do
    yield(candidate)
    if initial and not offered then
      offer_literal(candidate)
    end
  end
  if initial and not offered then
    offer_literal()
  end
end

return { processor = process, filter = filter }