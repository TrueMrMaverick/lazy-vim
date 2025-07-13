-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set;

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

local function copy_path_to_clipboard()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end

local function copy_cwd_relative_path_to_clipboard()
  local path = vim.fn.expand("%:p")
  local cwd = vim.fn.getcwd()
  path = path:sub(cwd:len() + 1)
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end

vim.api.nvim_create_user_command("Cppath", copy_path_to_clipboard, {})

local function copy_git_remote_url(add_line_number)
  local file_path = vim.fn.expand("%:p")

  local git_dir = vim.fn.systemlist("git rev-parse --git-dir")[1]
  if git_dir == "" then
    print("Couldn't fine git repo")
    return
  end

  local remote_url = vim.fn.trim(vim.fn.system("git config --get remote.origin.url"))
  if remote_url == "" then
    print("Couldn't get git remote url")
    return
  end

  local url = remote_url:gsub("ssh://git@", "https://")
  url = url:gsub("/av/", "/av/repos/")
  url = url:gsub(".git", "/browse")
  url = url:gsub(":%d+", "/projects")
  local index = file_path:find("/src")
  file_path = file_path:sub(index)
  url = url .. file_path

  if add_line_number == true then
    url = url .. "#" .. vim.fn.line(".")
  end

  vim.cmd('let @+ = "' .. url:gsub('"', '\\"') .. '"')
  print("URL copied: " .. url)
end

vim.keymap.set("n", "<leader>gpy", function()
  copy_git_remote_url(false)
end, {
  desc = "Yank repo link url",
})

vim.keymap.set("n", "<leader>gpY", function()
  copy_git_remote_url(true)
end, {
  desc = "Yank repo link url with line",
})

vim.keymap.set("n", "<leader>yp", copy_path_to_clipboard, {
  desc = "Yank path to the file",
})

vim.keymap.set("n", "<leader>yP", copy_cwd_relative_path_to_clipboard, {
  desc = "Yank path to the file relative to <cwd>",
})

map("n", "<leader>ft", function()
  local path = vim.fn.expand("%:p"):match("^(.*[/\\])") or "";
  Snacks.terminal(nil, { cwd = path })
end, { desc = "Terminal current file dir" })
