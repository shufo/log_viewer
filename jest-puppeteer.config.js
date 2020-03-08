module.exports = {
  server: {
    command: 'mix run --no-halt -e "require Logger; :timer.sleep(5000); Logger.info(\'test_log\')"',
    port: 5900
  },
};
