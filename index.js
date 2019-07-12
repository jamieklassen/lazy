'use strict';

const puppeteer = require('puppeteer');

async function main() {
  var browser = await puppeteer.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  var page = await browser.newPage();
  page.on('console', msg => {
    console.log(msg.text());
  });
  await page.goto(`file://${process.argv[2]}`);
  await page.evaluate(
    `app.ports.customPort.send("deeply nested")`
  );
  await page.waitForFunction(
    `document.querySelector("body").innerText.includes("deeply nested")`
  );
  await page.evaluate(
    `app.ports.canaryPort.send("canary")`
  );
  await page.waitForFunction(
    `document.querySelector("body").innerText.includes("canary")`
  );
  process.exit(0);
}

main();
