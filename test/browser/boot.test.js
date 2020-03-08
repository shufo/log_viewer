beforeAll(async () => {
  await page.goto('http://localhost:5900/');
});

afterAll(async done => {
  done();
});

it('should display loading page', async () => {
  const text = await page.evaluate(
    () => document.querySelector('#waiting_text').textContent,
  );
  expect(text).toBe('Waiting for logs matching the conditions to coming in...');
});