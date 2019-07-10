'use strict';

const puppeteer = require('puppeteer');

async function main() {
  var browser = await puppeteer.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  var page = await browser.newPage();
  page.on('console', msg => {
    var text = msg.text();
    console.log(text);
    if (text.includes("end")) {
      process.exit(0);
    }
  });
  await page.goto(`file://${process.argv[2]}`);
  await page.evaluate(() => {
    var app = Elm.Main.init({ node: document.body });
  });
  await page.evaluate(() => {
    app.ports.inbox.send("foo");
  });
  await page.evaluate(() => {
    app.ports.inbox.send("bar");
  });
  await page.evaluate(() => {
    app.ports.inbox.send("end");
  });
}

main();
