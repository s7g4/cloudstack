var synthetics = require('Synthetics');
const log = require('SyntheticsLogger');

const pageLoadBlueprint = async function () {
    const url = process.env.URL || 'http://${var.alb_dns_name}';
    let page = await synthetics.getPage();
    const response = await page.goto(url, {waitUntil: 'domcontentloaded', timeout: 30000});
    if (!response) {
        throw "Failed to load page!";
    }
    let status = response.status();
    log.info('Response status: ' + status);
    if (status !== 200) {
        throw "Failed to load page! Status: " + status;
    }
};

exports.handler = async () => {
    return await pageLoadBlueprint();
};
