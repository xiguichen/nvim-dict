local api = vim.api

-- Function to fetch word meaning from the Free Dictionary API
local function fetch_english_meaning(word)
  local url = "https://api.dictionaryapi.dev/api/v2/entries/en/" .. word
  local handle = io.popen("curl -s " .. url)
  local result = handle:read("*a")
  handle:close()
  local data = vim.fn.json_decode(result)
  if data and data[1] and data[1].meanings then
    return data[1].meanings[1].definitions[1].definition
  else
    return "No definition found"
  end
end

-- Function to fetch word meaning from a Chinese dictionary API
local function fetch_chinese_meaning(word)
  local url = "https://api.dictionaryapi.dev/api/v2/entries/zh/" .. word
  local handle = io.popen("curl -s " .. url)
  local result = handle:read("*a")
  handle:close()
  local data = vim.fn.json_decode(result)
  if data and data[1] and data[1].meanings then
    return data[1].meanings[1].definitions[1].definition
  else
    return "未找到定义"
  end
end

-- Function to show the meaning of the current word under the cursor
local function show_word_meaning()
  local word = vim.fn.expand("<cword>")
  local english_meaning = fetch_english_meaning(word)
  local chinese_meaning = fetch_chinese_meaning(word)

  -- Create a new buffer and window
  local buf = api.nvim_create_buf(false, true)
  local width = 50
  local height = 10
  local opts = {
    relative = 'cursor',
    width = width,
    height = height,
    col = 0,
    row = 1,
    style = 'minimal',
    border = 'rounded'
  }
  local win = api.nvim_open_win(buf, true, opts)

  -- Set buffer content
  local lines = {
    "Word: " .. word,
    "",
    "English Meaning:",
    english_meaning,
    "",
    "Chinese Meaning:",
    chinese_meaning
  }
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

-- Map the function to a hotkey
api.nvim_set_keymap('n', '<leader>m', ':lua require("nvim-dict").show_word_meaning()<CR>', { noremap = true, silent = true })

-- Return the module
return {
  show_word_meaning = show_word_meaning
}

