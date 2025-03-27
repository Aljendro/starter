local utils = require("CopilotChat.utils")

local COPILOT_PLUGIN_CONFIG = [[
Below is all the documentation for the plugin.

#################  Contents of config
{
  -- default contexts
  -- see config/contexts.lua for implementation
  contexts = {
    buffer = {
    },
    buffers = {
    },
    file = {
    },
    files = {
    },
    git = {
    },
    url = {
    },
    register = {
    },
    quickfix = {
    },
    system = {
    }
  },

  -- default prompts
  -- see config/prompts.lua for implementation
  prompts = {
    Explain = {
      prompt = 'Write an explanation for the selected code as paragraphs of text.',
      system_prompt = 'COPILOT_EXPLAIN',
    },
    Review = {
      prompt = 'Review the selected code.',
      system_prompt = 'COPILOT_REVIEW',
    },
    Fix = {
      prompt = 'There is a problem in this code. Identify the issues and rewrite the code with fixes. Explain what was wrong and how your changes address the problems.',
    },
    Optimize = {
      prompt = 'Optimize the selected code to improve performance and readability. Explain your optimization strategy and the benefits of your changes.',
    },
    Docs = {
      prompt = 'Please add documentation comments to the selected code.',
    },
    Tests = {
      prompt = 'Please generate tests for my code.',
    },
    Commit = {
      prompt = 'Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.',
      context = 'git:staged',
    },
  },
}

#################  Contents of config/contexts.lua

local context = require('CopilotChat.context')
local utils = require('CopilotChat.utils')

---@class CopilotChat.config.context
---@field description string?
---@field input fun(callback: fun(input: string?), source: CopilotChat.source)?
---@field resolve fun(input: string?, source: CopilotChat.source, prompt: string):table<CopilotChat.context.embed>

---@type table<string, CopilotChat.config.context>
return {
  buffer = {
    description = 'Includes specified buffer in chat context. Supports input (default current).',
    input = function(callback)
      vim.ui.select(
        vim.tbl_map(
          function(buf)
            return { id = buf, name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':p:.') }
          end,
          vim.tbl_filter(function(buf)
            return utils.buf_valid(buf) and vim.fn.buflisted(buf) == 1
          end, vim.api.nvim_list_bufs())
        ),
        {
          prompt = 'Select a buffer> ',
          format_item = function(item)
            return item.name
          end,
        },
        function(choice)
          callback(choice and choice.id)
        end
      )
    end,
    resolve = function(input, source)
      input = input and tonumber(input) or source.bufnr

      utils.schedule_main()
      return {
        context.get_buffer(input),
      }
    end,
  },

  buffers = {
    description = 'Includes all buffers in chat context. Supports input (default listed).',
    input = function(callback)
      vim.ui.select({ 'listed', 'visible' }, {
        prompt = 'Select buffer scope> ',
      }, callback)
    end,
    resolve = function(input)
      input = input or 'listed'

      utils.schedule_main()
      return vim.tbl_map(
        context.get_buffer,
        vim.tbl_filter(function(b)
          return utils.buf_valid(b) and vim.fn.buflisted(b) == 1 and (input == 'listed' or #vim.fn.win_findbuf(b) > 0)
        end, vim.api.nvim_list_bufs())
      )
    end,
  },

  file = {
    description = 'Includes content of provided file in chat context. Supports input.',
    input = function(callback, source)
      local files = utils.scan_dir(source.cwd(), {
        max_count = 0,
      })

      utils.schedule_main()
      vim.ui.select(files, {
        prompt = 'Select a file> ',
      }, callback)
    end,
    resolve = function(input)
      if not input or input == '' then
        return {}
      end

      utils.schedule_main()
      return {
        context.get_file(utils.filepath(input), utils.filetype(input)),
      }
    end,
  },

  files = {
    description = 'Includes all non-hidden files in the current workspace in chat context. Supports input (glob pattern).',
    input = function(callback)
      vim.ui.input({
        prompt = 'Enter glob> ',
      }, callback)
    end,
    resolve = function(input, source)
      local files = utils.scan_dir(source.cwd(), {
        glob = input,
      })

      utils.schedule_main()
      files = vim.tbl_filter(
        function(file)
          return file.ft ~= nil
        end,
        vim.tbl_map(function(file)
          return {
            name = utils.filepath(file),
            ft = utils.filetype(file),
          }
        end, files)
      )

      return vim
        .iter(files)
        :map(function(file)
          return context.get_file(file.name, file.ft)
        end)
        :filter(function(file_data)
          return file_data ~= nil
        end)
        :totable()
    end,
  },

  filenames = {
    description = 'Includes names of all non-hidden files in the current workspace in chat context. Supports input (glob pattern).',
    input = function(callback)
      vim.ui.input({
        prompt = 'Enter glob> ',
      }, callback)
    end,
    resolve = function(input, source)
      local out = {}
      local files = utils.scan_dir(source.cwd(), {
        glob = input,
      })

      local chunk_size = 100
      for i = 1, #files, chunk_size do
        local chunk = {}
        for j = i, math.min(i + chunk_size - 1, #files) do
          table.insert(chunk, files[j])
        end

        local chunk_number = math.floor(i / chunk_size)
        local chunk_name = chunk_number == 0 and 'file_map' or 'file_map' .. tostring(chunk_number)

        table.insert(out, {
          content = table.concat(chunk, '\n'),
          filename = chunk_name,
          filetype = 'text',
          score = 0.1,
        })
      end

      return out
    end,
  },

  git = {
    description = 'Requires `git`. Includes current git diff in chat context. Supports input (default unstaged, also accepts commit number).',
    input = function(callback)
      vim.ui.select({ 'unstaged', 'staged' }, {
        prompt = 'Select diff type> ',
      }, callback)
    end,
    resolve = function(input, source)
      input = input or 'unstaged'
      local cmd = {
        'git',
        '-C',
        source.cwd(),
        'diff',
        '--no-color',
        '--no-ext-diff',
      }

      if input == 'staged' then
        table.insert(cmd, '--staged')
      elseif input == 'unstaged' then
        table.insert(cmd, '--')
      else
        table.insert(cmd, input)
      end

      local out = utils.system(cmd)

      return {
        {
          content = out.stdout,
          filename = 'git_diff_' .. input,
          filetype = 'diff',
        },
      }
    end,
  },

  url = {
    description = 'Includes content of provided URL in chat context. Supports input.',
    input = function(callback)
      vim.ui.input({
        prompt = 'Enter URL> ',
        default = 'https://',
      }, callback)
    end,
    resolve = function(input)
      return {
        context.get_url(input),
      }
    end,
  },

  register = {
    description = 'Includes contents of register in chat context. Supports input (default +, e.g clipboard).',
    input = function(callback)
      local choices = utils.kv_list({
        ['+'] = 'synchronized with the system clipboard',
        ['*'] = 'synchronized with the selection clipboard',
        ['"'] = 'last deleted, changed, or yanked content',
        ['0'] = 'last yank',
        ['-'] = 'deleted or changed content smaller than one line',
        ['.'] = 'last inserted text',
        ['%'] = 'name of the current file',
        [':'] = 'most recent executed command',
        ['#'] = 'alternate buffer',
        ['='] = 'result of an expression',
        ['/'] = 'last search pattern',
      })

      vim.ui.select(choices, {
        prompt = 'Select a register> ',
        format_item = function(choice)
          return choice.key .. ' - ' .. choice.value
        end,
      }, function(choice)
        callback(choice and choice.key)
      end)
    end,
    resolve = function(input)
      input = input or '+'

      utils.schedule_main()
      local lines = vim.fn.getreg(input)
      if not lines or lines == '' then
        return {}
      end

      return {
        {
          content = lines,
          filename = 'vim_register_' .. input,
          filetype = '',
        },
      }
    end,
  },

  quickfix = {
    description = 'Includes quickfix list file contents in chat context.',
    resolve = function()
      utils.schedule_main()

      local items = vim.fn.getqflist()
      if not items or #items == 0 then
        return {}
      end

      local unique_files = {}
      for _, item in ipairs(items) do
        local filename = item.filename or vim.api.nvim_buf_get_name(item.bufnr)
        if filename then
          unique_files[filename] = true
        end
      end

      local files = vim.tbl_filter(
        function(file)
          return file.ft ~= nil
        end,
        vim.tbl_map(function(file)
          return {
            name = utils.filepath(file),
            ft = utils.filetype(file),
          }
        end, vim.tbl_keys(unique_files))
      )

      return vim
        .iter(files)
        :map(function(file)
          return context.get_file(file.name, file.ft)
        end)
        :filter(function(file_data)
          return file_data ~= nil
        end)
        :totable()
    end,
  },

  system = {
    description = \[\[Includes output of provided system shell command in chat context. Supports input.

Important:
- Only use system commands as last resort, they are run every time the context is requested.
- For example instead of curl use the url context, instead of finding and grepping try to check if there is any context that can query the data you need instead.
- If you absolutely need to run a system command, try to use read-only commands and avoid commands that modify the system state.
\]\],
    input = function(callback)
      vim.ui.input({
        prompt = 'Enter command> ',
      }, callback)
    end,
    resolve = function(input)
      if not input or input == '' then
        return {}
      end

      utils.schedule_main()

      local shell, shell_flag
      if vim.fn.has('win32') == 1 then
        shell, shell_flag = 'cmd.exe', '/c'
      else
        shell, shell_flag = 'sh', '-c'
      end

      local out = utils.system({ shell, shell_flag, input })
      if not out then
        return {}
      end

      local out_type = 'command_output'
      local out_text = out.stdout
      if out.code ~= 0 then
        out_type = 'command_error'
        if out.stderr and out.stderr ~= '' then
          out_text = out.stderr
        elseif not out_text or out_text == '' then
          out_text = 'Command failed with exit code ' .. out.code
        end
      end

      return {
        {
          content = out_text,
          filename = out_type .. '_' .. input:gsub('[^%w]', '_'):sub(1, 20),
          filetype = 'text',
        },
      }
    end,
  },
}

#################  Contents of config/prompts.lua

local COPILOT_BASE = string.format(
  \[\[
When asked for your name, you must respond with "GitHub Copilot".
Follow the user's requirements carefully & to the letter.
Follow Microsoft content policies.
Avoid content that violates copyrights.
If you are asked to generate content that is harmful, hateful, racist, sexist, lewd, violent, or completely irrelevant to software engineering, only respond with "Sorry, I can't assist with that."
Keep your answers short and impersonal.
The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
The user is working on a %s machine. Please respond with system specific commands if applicable.
You will receive code snippets that include line number prefixes - use these to maintain correct position references but remove them when generating output.

When presenting code changes:

1. For each change, first provide a header outside code blocks with format:
   [file:<file_name>](<file_path>) line:<start_line>-<end_line>

2. Then wrap the actual code in triple backticks with the appropriate language identifier.

3. Keep changes minimal and focused to produce short diffs.

4. Include complete replacement code for the specified line range with:
   - Proper indentation matching the source
   - All necessary lines (no eliding with comments)
   - No line number prefixes in the code

5. Address any diagnostics issues when fixing code.

6. If multiple changes are needed, present them as separate blocks with their own headers.
\]\],
  vim.uv.os_uname().sysname
)

local COPILOT_INSTRUCTIONS = \[\[
You are a code-focused AI programming assistant that specializes in practical software engineering solutions.
\]\] .. COPILOT_BASE

local COPILOT_EXPLAIN = \[\[
You are a programming instructor focused on clear, practical explanations.
\]\] .. COPILOT_BASE .. \[\[

When explaining code:
- Provide concise high-level overview first
- Highlight non-obvious implementation details
- Identify patterns and programming principles
- Address any existing diagnostics or warnings
- Focus on complex parts rather than basic syntax
- Use short paragraphs with clear structure
- Mention performance considerations where relevant
\]\]

local COPILOT_REVIEW = \[\[
You are a code reviewer focused on improving code quality and maintainability.
\]\] .. COPILOT_BASE .. \[\[

Format each issue you find precisely as:
line=<line_number>: <issue_description>
OR
line=<start_line>-<end_line>: <issue_description>

Check for:
- Unclear or non-conventional naming
- Comment quality (missing or unnecessary)
- Complex expressions needing simplification
- Deep nesting or complex control flow
- Inconsistent style or formatting
- Code duplication or redundancy
- Potential performance issues
- Error handling gaps
- Security concerns
- Breaking of SOLID principles

Multiple issues on one line should be separated by semicolons.
End with: "**`To clear buffer highlights, please ask a different question.`**"

If no issues found, confirm the code is well-written and explain why.
\]\]

---@class CopilotChat.config.prompt : CopilotChat.config.shared
---@field prompt string?
---@field description string?
---@field mapping string?

---@type table<string, CopilotChat.config.prompt>
return {
  COPILOT_BASE = {
    system_prompt = COPILOT_BASE,
  },

  COPILOT_INSTRUCTIONS = {
    system_prompt = COPILOT_INSTRUCTIONS,
  },

  COPILOT_EXPLAIN = {
    system_prompt = COPILOT_EXPLAIN,
  },

  COPILOT_REVIEW = {
    system_prompt = COPILOT_REVIEW,
  },

  Explain = {
    prompt = 'Write an explanation for the selected code as paragraphs of text.',
    system_prompt = 'COPILOT_EXPLAIN',
  },

  Review = {
    prompt = 'Review the selected code.',
    system_prompt = 'COPILOT_REVIEW',
    callback = function(response, source)
      local diagnostics = {}
      for line in response:gmatch('[^\r\n]+') do
        if line:find('^line=') then
          local start_line = nil
          local end_line = nil
          local message = nil
          local single_match, message_match = line:match('^line=(%d+): (.*)$')
          if not single_match then
            local start_match, end_match, m_message_match = line:match('^line=(%d+)-(%d+): (.*)$')
            if start_match and end_match then
              start_line = tonumber(start_match)
              end_line = tonumber(end_match)
              message = m_message_match
            end
          else
            start_line = tonumber(single_match)
            end_line = start_line
            message = message_match
          end

          if start_line and end_line then
            table.insert(diagnostics, {
              lnum = start_line - 1,
              end_lnum = end_line - 1,
              col = 0,
              message = message,
              severity = vim.diagnostic.severity.WARN,
              source = 'Copilot Review',
            })
          end
        end
      end
      vim.diagnostic.set(vim.api.nvim_create_namespace('copilot-chat-diagnostics'), source.bufnr, diagnostics)
      return response
    end,
  },

  Fix = {
    prompt = 'There is a problem in this code. Identify the issues and rewrite the code with fixes. Explain what was wrong and how your changes address the problems.',
  },

  Optimize = {
    prompt = 'Optimize the selected code to improve performance and readability. Explain your optimization strategy and the benefits of your changes.',
  },

  Docs = {
    prompt = 'Please add documentation comments to the selected code.',
  },

  Tests = {
    prompt = 'Please generate tests for my code.',
  },

  Commit = {
    prompt = 'Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.',
    context = 'git:staged',
  },
}
]]

return {
  -- Add custom context to extract ticket ID from branch name
  git_branch = {
    description = "Extracts the current git branch name and any ticket IDs (like AOPS-123456).",
    resolve = function(_, source)
      local cmd = {
        "git",
        "-C",
        source.cwd(),
        "branch",
        "--show-current",
      }
      local out = utils.system(cmd)

      local branch = out.stdout:gsub("[\r\n]", "")
      local ticket = branch:match("(%w+%-%d+)")

      return {
        {
          content = "Git branch: " .. branch .. (ticket and "\nTicket ID: " .. ticket or ""),
          filename = "git_branch_info",
          filetype = "text",
        },
      }
    end,
  },
  copilot_plugin_config = {
    description = "Includes the documentation for the Copilot plugin.",
    resolve = function()
      return {
        {
          content = COPILOT_PLUGIN_CONFIG,
          filename = "copilot_plugin_config",
          filetype = "text",
        },
      }
    end,
  },
}
