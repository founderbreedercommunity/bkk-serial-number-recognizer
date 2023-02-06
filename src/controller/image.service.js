'use strict'
var AWS = require('aws-sdk')
var rekognition = new AWS.Rekognition()
const s3 = new AWS.S3()
const fileType = require('file-type')
const _ = require('lodash')

module.exports.detect = async (event, context) => {
  console.log('Processing Handler ')
  console.log(event.pathParameters.id)
  console.log(process.env.BUCKETNAME)
  const imageData = event.body
  console.log(Object.prototype.toString.call(imageData))
  console.log(Object.keys(imageData))
  console.log('+++++++++++++++++++++++++++++++')
  console.log(imageData.size)
  console.log('========')
  // console.log(imageData)
  const imageFileBuffer = Buffer.from(imageData, 'base64')
  const fileName = event.pathParameters.id
  console.log(await fileType.fromBuffer(imageFileBuffer))

  const s3response = await saveFiletoS3(fileName, imageFileBuffer)
  console.log(s3response)
  // get text from uploaded images

  var params = {
    Image: {
      S3Object: {
        Bucket: process.env.BUCKETNAME,
        Name: fileName
      }
    }
  }
  const regex = /[0-9]/g
  var detectedText = []
  const firstAlphabet = /^[A-Z]{1}/
  const response = await getTextData(params)
  console.log(response)
  console.log(response.TextDetections.length)
  // var data = JSON.parse(response)
  var details = []
  response.TextDetections.forEach((element) => {
    if (element.Confidence > 90.1) {
      console.log(element.DetectedText)
      const found = element.DetectedText.match(regex)
      const firstcharAlphabet = element.DetectedText.match(firstAlphabet)
      if (firstcharAlphabet) detectedText.unshift(element.DetectedText)
      console.log(found)
      if (found && found.length > 0) {
        details.push(element)
        detectedText.push(element.DetectedText)
      } else {
        console.log('skipped:' + element)
      }
    }
  })
  // console.log(response);
  console.log('==============')
  console.log('response data' + JSON.stringify(details))
  console.log(_.union(detectedText))
  const responseData = { detectedText: _.union(detectedText), details: details }
  return responseData
  // return details
}

var getTextData = async function (params) {
  return new Promise((resolve, reject) => {
    rekognition.detectText(params, function (err, data) {
      if (err) {
        console.log(err)
        reject(err)
      }
      resolve(data)
    })
  })
}

var saveFiletoS3 = async function (fileFullName, buffer) {
  const params = {
    Bucket: process.env.BUCKETNAME,
    Key: fileFullName, // must be a path within your bucket and not an url like you have in fileFullPath,
    Body: buffer,
    ContentType: 'image/jpeg' // Sets the content type header, without this your browser cannot infer the type (browsers use mime types, not file extensions)
  }
  return new Promise((resolve, reject) => {
    s3.upload(params, function (err, data) {
      if (err) {
        console.log(err)
        reject(err)
      }
      resolve('success')
    })
  })
}
