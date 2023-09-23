const AWS = require('aws-sdk');
const sharp = require('sharp');

const s3 = new AWS.S3();

exports.handler = async (event) => {
    const bucket = event.Records[0].s3.bucket.name;
    const filename = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
    const processedFolder = 'processed/';

    const file = await s3.getObject({
        Bucket: bucket,
        Key: filename
    }).promise();

    // Process image to create different versions: large, small, and thumbnail
    const largeImage = await sharp(file.Body).resize(1024).toBuffer();
    const smallImage = await sharp(file.Body).resize(512).toBuffer();
    const thumbnail = await sharp(file.Body).resize(128).toBuffer();

    // Upload processed images back to the S3 bucket
    await s3.putObject({
        Bucket: bucket,
        Key: `${processedFolder}${filename}-large.jpg`,
        Body: largeImage,
        ContentType: 'image/jpeg'
    }).promise();

    await s3.putObject({
        Bucket: bucket,
        Key: `${processedFolder}${filename}-small.jpg`,
        Body: smallImage,
        ContentType: 'image/jpeg'
    }).promise();

    await s3.putObject({
        Bucket: bucket,
        Key: `${processedFolder}${filename}-thumbnail.jpg`,
        Body: thumbnail,
        ContentType: 'image/jpeg'
    }).promise();

    return {
        statusCode: 200,
        body: JSON.stringify({ message: "Images processed successfully!" }),
    };
};
