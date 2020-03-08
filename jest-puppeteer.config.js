module.exports = {
  server: {
    command: 'mix run --no-halt -e "require Logger; :timer.sleep(3000); Logger.info(\'test_log\')"',
    port: 5900
  },
};
