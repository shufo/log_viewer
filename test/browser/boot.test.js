beforeAll(async () => {
  await page.goto("http://localhost:5900/", { waitUntil: "domcontentloaded" });
});

afterAll(async done => {
  done();
});

it("should get info logs", async () => {
  await page.waitForSelector("#app_message_key", { visible: true, timeout: 30000 });
  const log = await page.evaluate(
    () => document.querySelector("#app_message_key").textContent
  );
  expect(log).toBe("test_log");
});
