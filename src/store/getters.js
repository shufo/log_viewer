export default {
  searchText(state) {
    return state.searchText
  },
  filterLevel(state) {
    return state.filterLevel
  },
  logs(state) {
    return state.logs
  },
  filteredLogs(state) {
    return state.logs.filter(function(log) {
      if (state.filterLevel == 'all') {
        return log.msg.toLowerCase().includes(state.searchText.toLowerCase())
      }

      return (
        log.msg.toLowerCase().includes(state.searchText.toLowerCase()) &&
        log.md.level == state.filterLevel
      )
    })
  },
  logsWithId(state) {
    return state.logs.reduce((acc, log) => {
      acc[log.id] = log
      return acc
    }, {})
  },
  logCount(state) {
    return state.logs.length
  },
  infoLogs(state) {
    return state.logs.filter((log, index) => log.md.level == 'info')
  },
  infoLogsCount(state, getters) {
    return getters.infoLogs.length
  },
  debugLogs(state) {
    return state.logs.filter((log, index) => log.md.level == 'debug')
  },
  debugLogsCount(state, getters) {
    return getters.debugLogs.length
  },
  warnLogs(state) {
    return state.logs.filter(log => log.md.level == 'warn')
  },
  warnLogsCount(state, getters) {
    return getters.warnLogs.length
  },
  errorLogs(state) {
    return state.logs.filter(log => log.md.level == 'error')
  },
  errorLogsCount(state, getters) {
    return getters.errorLogs.length
  }
}
