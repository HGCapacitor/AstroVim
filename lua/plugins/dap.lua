if true then return {} end -- DISABLED: Mason-nvim-dap clone issue

-- Debug Adapter Protocol (DAP) configuration for Neovim
-- Remote debugging: .NET app in Docker container, Neovim on host

---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      -- "WhoIsSethDaniel/mason-nvim-dap.nvim", -- TEMPORARILY DISABLED - network issue
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup()

      -- Automatically open/close DAP UI
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- .NET/C# debugger using Docker wrapper
      -- Absolute path to wrapper: /home/herman/.local/bin/vsdbg-docker
      dap.adapters.coreclr = {
        type = "executable",
        command = "/home/herman/.local/bin/vsdbg-docker",
        args = {},
      }

      -- Helper function to get container dotnet PID
      local function get_container_pid()
        local handle = io.popen(
          "docker exec devcontainer-app-1 pgrep -f 'dotnet' | head -1"
        )
        if not handle then
          return nil
        end
        local pid = handle:read("*a"):match("(%d+)")
        handle:close()
        return pid
      end

      -- Remote debugging configuration
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Attach to Container (Auto-detect)",
          mode = "local",
          request = "attach",
          processId = function()
            local pid = get_container_pid()
            if not pid then
              vim.notify(
                "❌ No dotnet process found. Start with:\n"
                  .. "docker exec devcontainer-app-1 bash -c 'cd /workspaces/data-fetcher && dotnet run'",
                vim.log.levels.ERROR
              )
              return nil
            end
            vim.notify("✅ Attaching to PID: " .. pid, vim.log.levels.INFO)
            return pid
          end,
        },
        {
          type = "coreclr",
          name = "Attach to Container (Manual PID)",
          mode = "local",
          request = "attach",
          processId = function()
            local input_pid = vim.fn.input("Enter container process ID: ")
            if input_pid == "" then
              return nil
            end
            return tonumber(input_pid)
          end,
        },
      }

      -- Keybindings for debugging
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<F5>", dap.continue, opts)
      vim.keymap.set("n", "<F10>", dap.step_over, opts)
      vim.keymap.set("n", "<F11>", dap.step_into, opts)
      vim.keymap.set("n", "<F12>", dap.step_out, opts)
      vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, opts)
      vim.keymap.set("n", "<Leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, opts)
      vim.keymap.set("n", "<Leader>dR", dap.run_last, opts)
      vim.keymap.set("n", "<Leader>dq", dap.quit, opts)
      vim.keymap.set("n", "<Leader>du", dapui.toggle, opts)
      vim.keymap.set("n", "<Leader>de", dapui.eval, opts)
    end,
  },
  {
    "WhoIsSethDaniel/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {},
      automatic_installation = false,
    },
  },
}

