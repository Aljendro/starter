return {
  -- Add custom prompt for conventional commits
  CBCommit = {
    prompt = "Write a conventional commit message for the staged changes. If a ticket ID (like AOPS-123456) is found in the branch name, include it in the commit message. Do not include a scope. Format as: type: TICKET-ID: message. Keep the title under 50 characters and wrap body text at 72 characters. Format as a gitcommit code block.",
    context = { "git:staged", "git_branch" },
  },
}
