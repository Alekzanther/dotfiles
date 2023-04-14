local present, null_ls = pcall(require, "null-ls")

if not present then
   return
end

local b = null_ls.builtins

local sources = {

  b.formatting.prettierd,
  b.diagnostics.eslint_d,
  b.code_actions.eslint_d,
  b.formatting.stylua,
  b.formatting.rustfmt,
  -- Shell
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
}

null_ls.setup {
   debug = true,
   sources = sources,
}
