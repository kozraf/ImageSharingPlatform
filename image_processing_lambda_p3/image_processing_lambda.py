import boto3
import os
import uuid
from urllib.parse import unquote_plus
from PIL import Image
import PIL.Image

s3_client = boto3.client('s3')


def resize_image(image_path, resized_path, size):
    with Image.open(image_path) as image:
        image.thumbnail(size)
        image.save(resized_path)


def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = unquote_plus(record['s3']['object']['key'])
        tmpkey = key.replace('/', '')

        # Download the original image from S3 to Lambda temp space
        download_path = '/tmp/{}{}'.format(uuid.uuid4(), tmpkey)
        s3_client.download_file(bucket, key, download_path)

        # Define sizes for large, small, and thumbnail versions
        sizes = {
            'large': (1024, 1024),
            'small': (512, 512),
            'thumbnail': (128, 128)
        }

        # Process and upload each image size to the "Processed" folder in S3
        for size_name, size_value in sizes.items():
            upload_path = '/tmp/{}_{}'.format(size_name, tmpkey)
            resize_image(download_path, upload_path, size_value)

            new_key = 'Processed/{}_{}'.format(size_name, key)
            s3_client.upload_file(upload_path, bucket, new_key)
