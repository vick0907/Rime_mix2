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

local function select_literal(context, spans, initial, start, length, prefix_text)
  context:pop_input(length)
  if prefix_text and prefix_text ~= "" then
    local segment = context.composition:back()
    local index = 0
    local found = false
    while segment and segment.menu do
      local candidate = segment:get_candidate_at(index)
      if not candidate then
        break
      end
      if candidate.text == prefix_text and candidate._end == start then
        segment.selected_index = index
        segment.status = "kSelected"
        found = true
        break
      end
      index = index + 1
    end
    if not found then
      context:push_input(initial .. " ")
      return false
    end
  end
  context:push_input("';" .. initial .. "'")
  spans[start] = initial
  local composition = context.composition
  local suffix = composition:back()
  if suffix and suffix:has_tag("all_bpm_suffix") then
    suffix.status = "kSelected"
    composition:push_back(Segment(#context.input, #context.input))
  end
  return true
end

local function init_memory(env)
  local config = env.engine.schema.config
  env.minimum_commits = config:get_int("mixed_learning/minimum_commits") or 3
  if config:get_bool("mixed_learning/enable_user_dict") ~= false then
    env.memory = Memory(env.engine, env.engine.schema, "mixed_learning")
  end
end

local function preference(env, code)
  if env.memory and env.memory:user_lookup(code, false) then
    for entry in env.memory:iter_user() do
      if entry.commit_count >= env.minimum_commits then
        return entry.text
      end
    end
  end
end

local function range_text(context, beginning, finish)
  local texts = {}
  for _, segment in ipairs(context.composition:toSegmentation():get_segments()) do
    if segment.start >= beginning and segment._end <= finish then
      local candidate = segment:get_selected_candidate()
      if candidate then
        texts[#texts + 1] = candidate.text
      elseif not segment:has_tag("phony") and segment.start < segment._end then
        return
      end
    elseif segment.start < finish and segment._end > beginning then
      return
    end
  end
  return table.concat(texts)
end

local function init_processor(env)
  init_memory(env)
  env.pending_choices = {}
  if env.memory then
    env.commit_connection = env.engine.context.commit_notifier:connect(function(context)
      local records = {}
      local positions = {}
      for start, choice in pairs(env.pending_choices) do
        if context.input:sub(start + 1, start + 4) == "';" .. choice.initial .. "'"
            and range_text(context, choice.beginning, start + 4) == choice.text then
          records[choice.code .. "\t" .. choice.text] = { code = choice.code, text = choice.text }
          positions[#positions + 1] = start
        end
      end
      if #positions > 0 then
        table.sort(positions, function(first, second) return first > second end)
        local code = context.input
        for _, start in ipairs(positions) do
          code = code:sub(1, start) .. env.pending_choices[start].initial .. code:sub(start + 5)
        end
        code = code:gsub(" +$", "")
        local text = range_text(context, 0, #context.input)
        if text and text ~= "" and not code:find("';", 1, true) then
          records[code .. "\t" .. text] = { code = code, text = text }
        end
      end
      for _, record in pairs(records) do
        local entry = DictEntry()
        entry.text = record.text
        entry.custom_code = record.code .. " "
        env.memory:update_userdict(entry, 1, "")
      end
      env.memory:finish_session()
      env.pending_choices = {}
    end)
  end
end

local function fini_memory(env)
  if env.commit_connection then
    env.commit_connection:disconnect()
  end
  if env.memory then
    env.memory:finish_session()
    env.memory:disconnect()
  end
end

local function process(key, env)
  local context = env.engine.context
  local spans = env.bopomofo_spans or {}
  env.bopomofo_spans = spans
  for start, initial in pairs(spans) do
    if context.input:sub(start + 1, start + 4) ~= "';" .. initial .. "'" then
      spans[start] = nil
      env.pending_choices[start] = nil
    end
  end
  local key_name = key:repr()
  if key_name == "BackSpace" then
    local start = context.caret_pos - 4
    if spans[start] then
      for _, segment in ipairs(context.composition:toSegmentation():get_segments()) do
        if segment._end == start and segment.status == "kSelected" then
          segment.status = "kGuess"
        end
      end
      context:pop_input(4)
      spans[start] = nil
      env.pending_choices[start] = nil
      return 1
    end
  elseif key_name == "Escape" and next(spans) then
    context:clear()
    env.bopomofo_spans = {}
    env.pending_choices = {}
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
      local choice = {
        code = context.input:sub(selected.start + 1, selected._end - 1),
        text = selected.text,
        beginning = selected.start,
        initial = initial
      }
      local prefix_text
      if start > selected.start then
        prefix_text = selected.text:sub(1, utf8.offset(selected.text, -1) - 1)
      end
      if select_literal(context, spans, initial, start, 2, prefix_text) then
        env.pending_choices[start] = choice
        return 1
      end
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
  local preferred
  if initial then
    preferred = preference(env, context.input:sub(segment.start + 1, segment._end - 1))
  end
  local function make_literal(source)
    local prefix = ""
    if preferred and preferred:sub(utf8.offset(preferred, -1)) == utf8.char(optional_symbols[initial]) then
      prefix = preferred:sub(1, utf8.offset(preferred, -1) - 1)
    elseif start > segment.start then
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
    return candidate
  end
  for candidate in input:iter() do
    local literal = initial and not offered and make_literal(candidate)
    if literal then
      if preferred == literal.text then
        yield(literal)
        yield(candidate)
      else
        yield(candidate)
        yield(literal)
      end
      offered = true
    else
      yield(candidate)
    end
  end
  if initial and not offered then
    local literal = make_literal()
    if literal then
      yield(literal)
    end
  end
end

return {
  processor = { init = init_processor, func = process, fini = fini_memory },
  filter = { init = init_memory, func = filter, fini = fini_memory }
}