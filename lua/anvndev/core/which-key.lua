local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

which_key.setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  operators = { gc = "Comments" },
  key_labels = {
    ["<space>"] = "SPC",
    ["<cr>"] = "RET",
    ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
  window = {
    border = "rounded",
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 2, 2, 2, 2 },
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "left",
  },
  ignore_missing = true,
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
  show_help = true,
  show_keys = true,
  triggers = "auto",
  triggers_blacklist = {
    i = { "j", "k" },
    v = { "j", "k" },
  },
})

-- Register key groups
which_key.register({
  { "", group = "Debug" },
  { "", group = "Terminal" },
  { "", group = "Find/Files" },
  { "", group = "LSP" },
  { "", group = "Code" },
  { "", group = "Buffers" },
  { "", group = "Git" },
  { "", group = "Refactor" },
  { "", group = "Workspace" },
  { "", group = "Toggle" },
  { "", group = "Text" },
}) 