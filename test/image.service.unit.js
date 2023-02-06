/* eslint-disable no-undef */
/* globals describe, it */
'use strict'

const assert = require('assert')
const handler = require('../src/api').handler
const chai = require('chai')
const chaiMatchPattern = require('chai-match-pattern')
chai.use(chaiMatchPattern)
const mockedEnv = require('mocked-env')
const log = require('why-is-node-running')
const fs = require('fs')

describe('Handler', () => {
  describe('SERIAL NUMBER Operation', () => {
    let restore
    // eslint-disable-next-line no-undef
    beforeEach(() => {
      restore = mockedEnv({
        BUCKETNAME: 'lpar'
      })
    })

    it('Add environment  - 200 with message', async () => {
      var imagedata = fs.readFileSync('./test/data/117.jpg', { encoding: 'base64' })
      // console.log(imagedata)
      const event = {
        resource: '/{proxy+}',
        path: '/v1/findserialnumber/117.jpg',
        httpMethod: 'POST',
        queryStringParameters: {},
        pathParameters: {
          proxy: 'findserialnumber/117.jpeg'
        },
        stageVariables: null,
        body: imagedata
      }

      const context = {
        invokedFunctionArn:
          'arn:aws:lambda:us-west-2:539783510382:function:unit-test-dev'
      }

      const result = await handler(event, context)
      console.log(JSON.stringify(result))

      // assert.strictEqual(result.statusCode, 200, "Expecting a 200 response");
    })

    afterEach(() => {
      restore()
    })
  })
})
