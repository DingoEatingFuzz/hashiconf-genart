const path = require('path')
const fs = require('fs');
const express = require('express')
const watchr = require('watchr')

const sse = require('./sse')

const app = express()
const port = 3000

const connections = []
const broadcast = msg => connections.forEach(res => res.sseSend(msg));

app.use(sse)

app.get('/', (req, res) => res.sendFile(path.join(__dirname + '/index.html')))

app.get('/watch', (req, res) => {
  res.sseSetup()
  res.sseSend({ connected: true })
  fs.readFile('../hashiconf/latest.svg', 'utf8', (err, svg) => {
    if (err) console.log('uh oh')
    res.sseSend({ svg })
  })
  connections.push(res)
})

app.listen(port, () => console.log(`Example app listening on port ${port}!\n`))

const listener = (changeType, filePath) => {
  console.log(`Detected change: ${changeType}, ${filePath}`)
  if (filePath.endsWith('hashiconf/latest.svg')) {
    fs.readFile(filePath, 'utf8', (err, svg) => {
      if (err) console.log('uh oh')
      broadcast({ svg })
    });
  }
}
const next = err => {
  err && console.log('watch failed?', err);
}

const watchDir = path.join(__dirname, '..')
console.log(`Watching ${watchDir}`)
const stalker = watchr.open(watchDir, listener, next)
