return {
  "rcarriga/nvim-notify",
  keys = {
    {
      "<leader>snn",
      function()
        require("telescope").extensions.notify.notify()
      end,
      desc = "Find All Notifications",
    },
  },
}
