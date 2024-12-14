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
        cwd = function(_)
          return vim.fn.getcwd()
        end,
      },
    },
  },
}
