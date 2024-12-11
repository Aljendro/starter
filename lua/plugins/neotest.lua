return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-jest",
  },
  opts = {
    adapters = {
      ["neotest-jest"] = {
        jestCommand = "jest",
        -- jestConfigFile =  '',
        cwd = function(path)
          return vim.fn.getcwd()
        end,
      },
    },
  },
}
