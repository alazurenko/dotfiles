function cap --description "Capture to Workflowy inbox"
    if test (count $argv) -gt 0
        workflowy-capture $argv
    else
        workflowy-capture
    end
end
