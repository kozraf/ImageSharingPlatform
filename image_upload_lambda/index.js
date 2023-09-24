const AWS = require('aws-sdk');
const s3 = new AWS.S3();
const lambda = new AWS.Lambda();

exports.handler = async (event) => {
    console.log("Received event:", JSON.stringify(event, null, 2));  // Log the entire event

    const parsedBody = JSON.parse(event.body);
    console.log("Parsed body:", JSON.stringify(parsedBody, null, 2));  // Additional logging for the parsed body

    const base64Image = parsedBody.image?.replace(/^data:image\/\w+;base64,/, "");
    const buffer = base64Image ? Buffer.from(base64Image, 'base64') : null;

    if (!buffer) {
        return {
            statusCode: 400,
            body: JSON.stringify({ error: 'No image provided or incorrect format' }),
            headers: {
                'Access-Control-Allow-Origin': '*'
            }
        };
    }

    const filename = `uploads/${parsedBody.name}`;  // Updated to save in the "uploads" folder
    if (!filename) {
        return {
            statusCode: 400,
            body: JSON.stringify({ error: 'Filename not provided' }),
            headers: {
                'Access-Control-Allow-Origin': '*'
            }
        };
    }

    const params = {
        Bucket: process.env.S3_BUCKET,
        Key: filename,
        Body: buffer,
        ContentEncoding: 'base64',
        ContentType: 'image/jpeg'
    };

    try {
        const s3Response = await s3.putObject(params).promise();

        // Construct the S3 event for imageProcessingFunction
        const s3Event = {
            Records: [
                {
                    s3: {
                        bucket: {
                            name: process.env.S3_BUCKET,
                        },
                        object: {
                            key: filename,
                        },
                    },
                },
            ],
        };

        // Invoke the imageProcessingFunction
        await lambda.invoke({
            FunctionName: "imageProcessingFunction",
            Payload: JSON.stringify(s3Event),
        }).promise();

        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'Image uploaded successfully!', data: s3Response }),
            headers: {
                'Access-Control-Allow-Origin': '*'
            }
        };
    } catch (error) {
        console.error(error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Failed to upload image' }),
            headers: {
                'Access-Control-Allow-Origin': '*'
            }
        };
    }
};
