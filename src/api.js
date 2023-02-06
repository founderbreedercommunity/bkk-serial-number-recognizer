'use strict'

const { Router } = require('lambda-router')
const logger = require('./util/logger')
const imageService = require('./controller/image.service')
const router = Router({
  logger,
  includeErrorStack: process.env.stage !== 'prod'
})
const version = 'v1'

// run before every route
// router.beforeRoute(validationservice.validateRequest)
// router.get('somePath', (event, context) => ({}))
// router to create a client
router.post(`/${version}/findserialnumber/{id}`, async (event, context) => {
  logger.info('Processing - protocol: Post image service');
  return imageService.detect(event, context)
})

exports.handler = logger.handler(handler)

async function handler (event, context) {
  context.callbackWaitsForEmptyEventLoop = false
  logger.setKey('path', event.path)
  console.log(event)
  //logger.info('Received event:', JSON.stringify(event, null, 2), JSON.stringify(context, null, 2))
  logger.info('Received event:')


  const result = await router.route(event, context)

  return result.response
}
