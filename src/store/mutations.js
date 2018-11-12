export default {
  ADD_LOG(state, log) {
    state.logs.unshift(log)
    state.logs.splice(state.maxLogs)
  },
  CHANGE_SEARCH_TEXT(state, text) {
    state.searchText = text
  },
  SET_LEVEL_FILTER(state, level) {
    state.filterLevel = level
  },
  CHANGE_MAX_LOGS(state, maxLogs) {
    state.maxLogs = maxLogs
  }
}
