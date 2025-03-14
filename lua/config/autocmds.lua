-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_user_command("Cppath", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

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
