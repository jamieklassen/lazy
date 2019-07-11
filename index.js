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
  var send = async msg => {
    await page.evaluate(
      `app.ports.unobservablePort.send("${msg}")`
    );
    await page.waitForFunction(
      `document.querySelector("body").innerText.includes("${msg}")`
    );
    await page.evaluate(
      `app.ports.msgPort.send("observable-${msg}")`
    );
    await page.waitForFunction(
      `document.querySelector("body").innerText.includes("observable-${msg}")`
    );
  }
  await send("foo");
  await send("bar");
  process.exit(0);
}

main();
