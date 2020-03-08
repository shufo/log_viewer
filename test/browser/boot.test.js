beforeAll(async () => {
  await page.goto("http://localhost:5900/", { waitUntil: "domcontentloaded" });
});

afterAll(async done => {
  done();
});

it("should display loading page", async () => {
  const text = await page.evaluate(
    () => document.querySelector("#waiting_text").textContent
  );
  expect(text).toBe("Waiting for logs matching the conditions to coming in...");
});

it("should get info logs", async () => {
  await page.waitForSelector("#app_message_key", { visible: true });
  const log = await page.evaluate(
    () => document.querySelector("#app_message_key").textContent
  );
  expect(log).toBe("test_log");
});
