const express = require('express');
const os = require('os');

// Constants
const VERSION = process.env.MYWEB_VERSION || '0';
const COLOR = `hsl(${Math.floor(Math.random() * 360)}, 80%, 70%)`;
const LISTEN_HOSTNAME = process.env.MYWEB_LISTEN_HOSTNAME || '0.0.0.0';
const LISTEN_PORT = process.env.MYWEB_LISTEN_PORT || '3000';
const HOSTNAME = os.hostname();

// Helper
function inspect(req) {
  const connection = req.connection;
  const data = [
    ['Version', VERSION],
    ['Hostname', HOSTNAME],
    ['Request', req.headers.host],
    ['Local Address', connection.localAddress],
    ['Local Port', connection.localPort],
    ["Remote Address", connection.remoteAddress],
    ["Remote Family", connection.remoteFamily],
    ["Remote Port", connection.remotePort],
    ["Bytes Read", connection.bytesRead],
    ["Bytes Written", connection.bytesWritten]
  ];
  const maxLabelLength = Math.max(...data.map(d => d[0].length));
  return data.map(d => `${`${d[0]}:`.padEnd(maxLabelLength + 2)}${d[1]}`).join("\n");
}

// App
const app = express();
app.set("view engine", "pug");

app.get("/", (req, res) => {
  res.render("color", {
    color: COLOR,
    message: inspect(req)
  });
});

app.get('/inspect', (req, res) => {
  res.status(200);
  res.set('Content-Type', 'text/plain');
  res.send(inspect(req));
});

app.listen(LISTEN_PORT, LISTEN_HOSTNAME, function () {
  console.log(`Listening on ${LISTEN_HOSTNAME}:${LISTEN_PORT}`);
});
