return {
  -- Add custom prompt for conventional commits
  CBCommit = {
    prompt = "Write a conventional commit message for the staged changes. If a ticket ID (like AOPS-123456) is found in the branch name, include it in the commit message. Do not include a scope. Format as: type: TICKET-ID: message. Keep the title under 50 characters and wrap body text at 72 characters. Format as a gitcommit code block.",
    context = { "git:staged", "git_branch" },
  },
  JQ = {
    prompt = "You are an expert in jq, the JSON query language. Generate a jq query for the provided JSON data to achieve the described transformation or extraction. I only need the command to input into nvim command mode. Provide a brief explanation of the query.",
    context = { "selection", "buffer" },
  },
}
