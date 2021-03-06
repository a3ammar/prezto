HISTDB_TABULATE_CMD=(sed -e $'s/.*\x1f//')
# Load the main functionality
source "${0:h}/external/sqlite-history.zsh"

# Add command timers to histdb
source "${0:h}/external/history-timer.zsh"

add-zsh-hook preexec _start_timer
add-zsh-hook precmd _stop_timer

# Integrate with zsh-autosuggestions
_zsh_autosuggest_strategy_histdb_top_here() {
    local query="select commands.argv from
history left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir LIKE '$(sql_escape $PWD)%'
and commands.argv LIKE '$(sql_escape $1)%'
group by commands.argv order by count(*) desc limit 1"
    _histdb_query "$query"
}

export ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here
