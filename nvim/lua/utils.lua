local M = {}

M.win32 = vim.fn.has('win32')

function M.get_os_path(unixish_path)
  if win32 then
    return string.gsub(unixish_path, '/', '\\')
  end
  return unixish_path
end


M.mason_path = vim.fn.stdpath('data') .. '/mason'
M.mason_bin_path = M.mason_path .. '/bin'
M.mason_cmd_suffix = ''

if win32 then
  M.mason_cmd_suffix  = '.cmd'
end

return M

