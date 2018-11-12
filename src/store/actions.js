export default {
  addLog({ commit }, log) {
    commit('ADD_LOG', log)
  },
  changeSearchText({ commit }, text) {
    commit('CHANGE_SEARCH_TEXT', text)
  },
  setLevelFilter({ commit }, level) {
    commit('SET_LEVEL_FILTER', level)
  },
  changeMaxLogs({ commit }, maxLogs) {
    commit('CHANGE_MAX_LOGS', maxLogs)
  }
}
