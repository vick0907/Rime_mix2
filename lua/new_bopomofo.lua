local initials = {
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
  ["v"] = 0x3112
}

return function(key, env)
  if key:repr() ~= "space" then
    return 2
  end
  local context = env.engine.context
  local segment = context.composition:back()
  local last_key = context.input:sub(-1)
  local prefix = context.input:sub(1, -2)
  local codepoint = initials[last_key]
  local separate_initial = prefix == "" or prefix:match("[ 3467]$")
    if codepoint and separate_initial and context.caret_pos == #context.input
      and not context:get_option("ascii_mode")
      and segment and segment:has_tag("abc")
      and segment.selected_index == 0 and not segment:has_tag("paging") then
    local text = ""
    if prefix ~= "" then
      context:pop_input(1)
      text = context:get_commit_text()
      if text == "" then
        context:push_input(last_key)
        return 2
      end
    end
    env.engine:commit_text(text .. utf8.char(codepoint))
    context:clear()
    return 1
  end
  return 2
end