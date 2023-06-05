require 'aws-sdk-s3'

class Uploader
  def upload(file, key:)
    client = Aws::S3::Client.new(
      endpoint: Environment.fetch('S3_ENDPOINT'),
      region: Environment.fetch('AWS_REGION'),
      force_path_style: true,
      access_key_id: Environment.fetch('AWS_ACCESS_KEY_ID'),
      secret_access_key: Environment.fetch('AWS_SECRET_ACCESS_KEY'),
    )

    s3 = Aws::S3::Resource.new(client: client)
    bucket = s3.bucket(Environment.fetch('S3_BUCKET'))
    object = bucket.object(key)

    object.upload_file(file, content_disposition: "attachment; filename=#{File.basename(file)}")

    return object.public_url
  end
end
