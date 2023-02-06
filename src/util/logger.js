'use strict'

const { Logger } = require('lambda-logger-node')
module.exports = Logger({
  useGlobalErrorHandler: true,
  useBearerRedactor: true,
  minimumLogLevel: process.env.LOGLEVEL
})
